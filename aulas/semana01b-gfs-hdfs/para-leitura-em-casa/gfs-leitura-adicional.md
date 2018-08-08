# Google File System


## Como o Google File System (GFS) funciona?

A Google é uma empresa multibilionária. É um dos grandes *players* na Web. Além disso, a empresa conta com um sistema de computação distribuída para fornecer aos usuários a infraestrutura necessária para acessar, criar e alterar dados. Com certeza, a Google compra computadores e servidores de última geração para manter suas operações funcionando sem problemas, certo?


Errado. As máquinas que alimentam as operações da Google não são computadores de ponta com muitos recursos ou frescuras. Na verdade, são máquinas baratas que rodam Linux. Mas, como uma das empresas mais influentes da Web pode confiar em hardware barato? Uma das razões é o uso do GFS, que aproveita os pontos fortes dos servidores, ao mesmo tempo que compensa pontos fracos do hardware. Está tudo no design.


A Google usa o GFS para não somente organizar e manipular arquivos enormes, mas também para permitir que desenvolvedores de aplicativos usem os recursos de pesquisa e desenvolvimento de que precisam. O GFS é exclusivo da Google e não está à venda. Mas serviu como modelo para o desenvolvimento de sistemas de arquivos para outras organizações com necessidades semelhantes.


Alguns detalhes do GFS são um mistério para qualquer pessoa fora da Google. Por exemplo, a Google não revela quantos computadores ele usa para operar o GFS. Nos documentos oficiais, a Google diz apenas que existem "milhares" de computadores no sistema. Mas, apesar do sigilo, a Google tornou boa parte da estrutura e da operação do GFS de conhecimento público.


Então, o que o GFS faz exatamente e por que ele é importante?


## Fundamentos do GFS

Os desenvolvedores da Google lidam rotineiramente com arquivos grandes que podem ser difíceis de manipular usando um sistema de arquivos de computador tradicional. O tamanho dos arquivos levou muitas das decisões que os programadores tiveram que tomar para o design do GFS. Outra grande preocupação era a escalabilidade, que se refere à facilidade de adicionar capacidade ao sistema. Um sistema é escalável, se é fácil aumentar a capacidade do sistema. O desempenho do sistema não deve sofrer à medida que cresce. A Google exige uma rede muito grande de computadores para lidar com todos os seus arquivos, portanto a escalabilidade é uma das principais preocupações.

Como a rede é tão grande, monitorar e manter é uma tarefa desafiadora. Enquanto desenvolviam o GFS, os programadores decidiram automatizar a maior parte das tarefas administrativas necessárias para manter o sistema funcionando. Este é um princípio fundamental da computação autonômica, um conceito em que os computadores são capazes de diagnosticar problemas e resolvê-los em tempo real, sem a necessidade de intervenção humana. O desafio para a equipe do GFS era não apenas criar um sistema de monitoramento automático, mas também projetá-lo para que ele pudesse funcionar em uma enorme rede de computadores.

A chave para os projetos da equipe era o conceito de simplificação. Eles chegaram à conclusão de que, à medida que os sistemas se tornam mais complexos, os problemas surgem com mais frequência. Uma abordagem simples é mais fácil de controlar, mesmo quando a escala do sistema é enorme.

Com base nessa filosofia, a equipe do GFS decidiu que os usuários teriam acesso aos comandos básicos do arquivo. Estes incluem comandos como abrir, criar, ler, escrever e fechar arquivos. A equipe também incluiu alguns comandos especializados: append e snapshot. Eles criaram os comandos especializados com base nas necessidades da Google. O comando append permite que os clientes adicionem informações a um arquivo existente sem sobrescrever dados previamente gravados. O comando snapshot cria uma cópia rápida do conteúdo de um computador.

Arquivos no GFS tendem a ser muito grandes, geralmente na ordem de vários gigabytes (GB). Acessar e manipular arquivos grandes ocuparia grande parte da largura de banda da rede. Largura de banda (em inglês, *bandwidth*) é a capacidade de um sistema para mover dados de um local para outro. O GFS resolve esse problema dividindo os arquivos em blocos de 64 megabytes (MB) cada. Cada *chunk* recebe um número de identificação exclusivo de 64 bits chamado de identificador de *chunk*. O GFS pode trabalhar com arquivos menores, embora o GFS não é otimizado para esses tipos de tarefas.


Ao exigir que todos os *chunks* de arquivos sejam do mesmo tamanho, o GFS simplifica o gerenciamento dos recursos. É fácil ver quais computadores no sistema estão próximos da capacidade e quais são subutilizados. Também é mais fácil fácil portar *chunks* de um recurso para outro para equilibrar a carga de trabalho no sistema.

Qual é o design real do GFS?


## Arquitetura do GFS

A Google organizou o GFS em *clusters* de computadores. Um *cluster* é simplesmente uma rede de computadores. Cada *cluster* pode conter centenas ou até milhares de máquinas. Nos *clusters* GFS, existem três tipos de entidades: clientes, servidores mestres e servidores de *chunk*.

No mundo do GFS, o termo "cliente" refere-se a qualquer entidade que faz uma solicitação de arquivo. As solicitações podem variar de recuperar e manipular arquivos existentes a criar novos arquivos no sistema. Os clientes podem ser outros computadores ou programas de computador. Você pode pensar nos clientes como os clientes do GFS.

O servidor mestre atua como o coordenador do *cluster*. As tarefas do mestre incluem a manutenção de um log de operação, que controla as atividades do *cluster* do mestre. O log de operação ajuda a manter as interrupções de serviço ao mínimo - se o servidor mestre falhar, um servidor de substituição que monitorou o log de operação poderá substituí-lo. O servidor mestre também controla os metadados, que são as informações que descrevem *chunks*. Os metadados informam ao servidor mestre para quais arquivos os *chunks* pertencem e onde eles se encaixam no arquivo geral. Na inicialização, o mestre pesquisa todos os servidores de *chunk* em seu *cluster*. Os servidores de *chunk* respondem informando ao servidor mestre o conteúdo de seus inventários. A partir desse momento, o servidor mestre controla a localização de *chunks* dentro do *cluster*.

Há apenas um servidor mestre ativo por *cluster* em qualquer momento (embora cada *cluster* tenha várias cópias do servidor mestre em caso de falha de hardware). Isso pode soar como uma boa receita para um gargalo - afinal, se há apenas uma máquina coordenando um *cluster* de milhares de computadores, isso não causaria engarrafamentos de dados? O GFS contorna essa situação complicada mantendo as mensagens que o servidor mestre envia e recebe muito pequenas. O servidor mestre na verdade não manipula dados de arquivo. Deixa isso para os servidores de *chunk*.

Servidores de *chunk* são os burros de carga do GFS. Eles são responsáveis por armazenar os blocos de arquivos de 64 MB. Os servidores de *chunk* não enviam *chunks* para o servidor mestre. Em vez disso, eles enviam *chunks* solicitados diretamente para o cliente. O GFS copia todos os *chunks* várias vezes e os armazenam em diferentes servidores de *chunk*. Cada cópia é chamada de réplica. Por padrão, o GFS faz três réplicas por *chunk*, mas os usuários podem alterar a configuração e criar mais ou menos réplicas, se desejado.

Como esses elementos funcionam juntos durante um processo de rotina?

## Usando o GFS

As solicitações de arquivos seguem um fluxo de trabalho padrão. Um pedido de leitura é simples - o cliente envia uma solicitação ao servidor mestre para descobrir onde o cliente pode encontrar um arquivo específico no sistema. O servidor responde com a localização da réplica primária do respectivo bloco. A réplica primária mantém uma concessão do servidor mestre para o fragmento em questão.

Se nenhuma réplica detiver atualmente uma concessão, o servidor mestre designará uma parte como a principal. Ele faz isso comparando o endereço IP do cliente com os endereços dos servidores de *chunk* que contêm as réplicas. O servidor mestre escolhe o servidor de *chunk* mais próximo do cliente. Esse *chunk* do servidor de *chunk* se torna o primário. Em seguida, o cliente contata diretamente o servidor de *chunk* apropriado, que envia a réplica ao cliente.

Pedidos de escrita são um pouco mais complicados. O cliente ainda envia uma solicitação ao servidor mestre, que responde com a localização das réplicas primárias e secundárias. O cliente armazena essas informações em um cache de memória. Dessa forma, se o cliente precisar se referir à mesma réplica posteriormente, poderá ignorar o servidor mestre. Se a réplica primária ficar indisponível ou a réplica mudar, o cliente precisará consultar o servidor mestre novamente antes de entrar em contato com um servidor de *chunk*.

O cliente envia os dados de escrita para todas as réplicas, começando com a réplica mais próxima e terminando com a réplica mais próxima. Não importa se a réplica mais próxima é primária ou secundária. a Google compara esse método de entrega de dados a um pipeline.

Depois que as réplicas receberem os dados, a réplica primária começará a atribuir números de série consecutivos a cada alteração no arquivo. Mudanças são chamadas de mutações. Os números de série instruem as réplicas sobre como ordenar cada mutação. O primário então aplica as mutações em ordem sequencial aos seus próprios dados. Em seguida, ele envia uma solicitação de escrita para as réplicas secundárias, que seguem o mesmo processo de aplicativo. Se tudo funcionar como deveria, todas as réplicas no *cluster* incorporarão os novos dados. As réplicas secundárias relatam de volta ao primário quando o processo de inscrição termina.

Nesse momento, a réplica primária reporta de volta ao cliente. Se o processo foi bem sucedido, termina aqui. Caso contrário, a réplica primária informa ao cliente o que aconteceu. Por exemplo, se uma réplica secundária não for atualizada com uma mutação específica, a réplica primária notificará o cliente e tentará novamente o aplicativo de mutação várias vezes mais. Se a réplica secundária não for atualizada corretamente, a réplica primária informará a réplica secundária para recomeçar a partir do início do processo de escrita. Se isso não funcionar, o servidor mestre identificará a réplica afetada como lixo.


O que mais o GFS faz e o que o servidor mestre faz com o lixo?

## Outras funções do GFS

Além dos serviços básicos oferecidos pelo GFS, existem algumas funções especiais que ajudam a manter o sistema funcionando sem problemas. Ao projetar o sistema, os desenvolvedores do GFS sabiam que certos problemas estavam prestes a surgir com base na arquitetura do sistema. Eles escolheram usar hardware barato, o que tornou a construção de um sistema grande um processo econômico. Isso também significava que os computadores individuais no sistema nem sempre seriam confiáveis. O preço barato andou de mãos dadas com computadores que tendem a falhar.

Os desenvolvedores do GFS construíram funções no sistema para compensar a falta de confiabilidade inerente de componentes individuais. Essas funções incluem replicação master e *chunk*, um processo de recuperação simplificado, rebalanceamento, detecção de réplicas obsoletas, remoção de lixo e checksum.

Embora exista apenas um servidor mestre ativo por *cluster* GFS, as cópias do servidor mestre existem em outras máquinas. Algumas cópias, chamadas de mestres de sombra, fornecem serviços limitados, mesmo quando o servidor mestre principal está ativo. Esses serviços são limitados a solicitações de leitura, uma vez que essas solicitações não alteram dados de nenhuma maneira. Os servidores mestres de sombra sempre ficam um pouco atrasados em relação ao servidor mestre primário, mas geralmente são apenas uma questão de frações de segundo. As réplicas do servidor mestre mantêm contato com o servidor mestre principal, monitorando o log de operações e os servidores de *chunk* de pesquisa para controlar os dados. Se o servidor mestre primário falhar e não puder ser reiniciado, um servidor mestre secundário poderá substituí-lo.

O GFS replica *chunks* para garantir que os dados estejam disponíveis mesmo se o hardware falhar. Ele armazena réplicas em diferentes máquinas em diferentes racks. Dessa forma, se um rack inteiro falhar, os dados ainda existirão em um formato acessível em outra máquina. O GFS usa o identificador de bloco exclusivo para verificar se cada réplica é válida. Se uma das alças da réplica não corresponder à alça do fragmento, o servidor mestre criará uma nova réplica e a atribuirá a um servidor de *chunk*.

O servidor mestre também monitora o *cluster* como um todo e reequilibra periodicamente a carga de trabalho, deslocando *chunks* de um servidor de *chunk* para outro. Todos os servidores de *chunk* funcionam na capacidade próxima, mas nunca na capacidade total. O servidor mestre também monitora *chunks* e verifica se cada réplica é atual. Se uma réplica não corresponder ao número de identificação do bloco, o servidor mestre a designará como uma réplica obsoleta. A réplica obsoleta se torna lixo. Após três dias, o servidor mestre pode excluir um *chunk* de lixo. Essa é uma medida de segurança - os usuários podem verificar um *chunk* de lixo antes de ser excluído permanentemente e evitar exclusões indesejadas.

Para evitar corrupção de dados, o GFS usa um sistema chamado soma de verificação. O sistema divide cada bloco de 64 MB em blocos de 64 kilobytes (KB). Cada bloco dentro de um fragmento tem sua própria soma de verificação de 32 bits, que é uma espécie de impressão digital. O servidor mestre monitora *chunks* olhando as somas de verificação. Se a soma de verificação de uma réplica não corresponder à soma de verificação na memória do servidor mestre, o servidor mestre excluirá a réplica e criará uma nova para substituí-la.

Que tipo de hardware a Google usa em seu GFS?

## Hardware do GFS

A Google diz pouco sobre o hardware que atualmente usa para rodar o GFS, além de ser uma coleção de servidores Linux baratos. Mas em um relatório oficial do GFS, a Google revelou as especificações do equipamento usado para executar alguns testes de desempenho do GFS. Embora o equipamento de teste possa não ser uma representação real do hardware GFS atual, ele dá uma idéia do tipo de computador que a Google usa para lidar com a enorme quantidade de dados que armazena e manipula.

O equipamento de teste incluiu um servidor master, duas réplicas master, 16 clientes e 16 servidores de *chunk*. Todos eles usaram o mesmo hardware com as mesmas especificações e todos eles rodaram em sistemas operacionais Linux. Cada um tinha dois processadores Pentium III de 1,4 gigahertz, 2 GB de memória e dois discos rígidos de 80 GB. Em comparação, vários fornecedores atualmente oferecem PCs de consumo que são mais do que duas vezes mais potentes que os usados pela Google em seus testes. Os desenvolvedores da Google provaram que o GFS poderia funcionar eficientemente usando equipamentos modestos.

A rede que conecta as máquinas juntas consistia em uma conexão Ethernet full-duplex de 100 megabytes por segundo (Mbps) e dois switches de rede Hewlett Packard 2524. Os desenvolvedores do GFS conectaram as 16 máquinas cliente a um switch e as outras 19 a outro switch. Eles associaram os dois switches a uma conexão de um gigabyte por segundo (Gbps).


Atrás da tecnologia de ponta, a Google pode comprar equipamentos e componentes a preços de barganha. A estrutura do GFS é tal que é fácil adicionar mais máquinas a qualquer momento. Se um *cluster* começar a se aproximar da capacidade total, a Google poderá adicionar hardware mais barato ao sistema e reequilibrar a carga de trabalho. Se a memória de um servidor mestre estiver sobrecarregada, a Google poderá atualizar o servidor mestre com mais memória. O sistema é verdadeiramente escalável.

Como a Google decidiu usar esse sistema? Alguns creditam a política de contratação da Google. A Google tem a reputação de contratar graduados em ciência da computação logo após a pós-graduação e de lhes fornecer os recursos e o espaço de que precisam para experimentar sistemas como o GFS. Outros dizem que vem de uma mentalidade de "faça o que você pode com o que você tem" que muitos desenvolvedores de sistemas de computador (incluindo os fundadores da Google) parecem possuir. No final, a Google provavelmente escolheu o GFS porque ele é voltado para lidar com os tipos de processos que ajudam a empresa a perseguir seu objetivo declarado de organizar as informações do mundo.


## Referência

https://computer.howstuffworks.com/internet/basics/google-file-system.htm
