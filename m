Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaGIEJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:09:34 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:40657 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750915AbaGIEJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:09:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:1:41:196:355:379:541:599:800:960:966:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1434:1437:1515:1516:1518:1593:1594:1605:1622:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2553:2559:2562
X-HE-Tag: balls13_8cbcc88cafa01
X-Filterd-Recvd-Size: 12502
Message-ID: <1404878965.932.87.camel@joe-AO725>
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Date: Tue, 08 Jul 2014 21:09:25 -0700
In-Reply-To: <20140708222557.GF4603@linux.vnet.ibm.com>
References: <20140707224146.GA9118@linux.vnet.ibm.com>
	 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140708080908.GN19379@twins.programming.kicks-ass.net>
	 <1404842784.932.22.camel@joe-AO725>
	 <20140708204124.GW4603@linux.vnet.ibm.com>
	 <1404853264.932.52.camel@joe-AO725>
	 <20140708215229.GA4603@linux.vnet.ibm.com>
	 <1404857116.932.68.camel@joe-AO725>
	 <20140708222557.GF4603@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 15:25 -0700, Paul E. McKenney wrote:
> On Tue, Jul 08, 2014 at 03:05:16PM -0700, Joe Perches wrote:
[]
> > I still think the concept is pretty useless and it's
> > just a duplication of "M:", which isn't anything other
> > than a list of who should be sent patches.
[]
> It will be interesting to see how things go.

Yes, it might work out fine and maybe might cause some
other beneficial changes.

> There did seem to be
> some people who were comfortable being listed as RCU reviewers, but
> not as RCU maintainers.  Perhaps the same thing happens elsewhere.

Maybe so.

I wrote a script to find which maintainer addresses that
haven't signed or authored a commit in the last 2 years.

I got ~250 entries.  That's about 1/4 of all maintainer
email addresses.

Maybe a dozen of these are false positives though because
some maintainers prefer to receive email at one address
but ack from another.

These are all lowercase for better matching.

abhijit mahajan <abhijit.mahajan@avagotech.com>
achim leubner <achim_leubner@adaptec.com>
adam radford <linuxraid@lsi.com>
al cho <acho@novell.com>
ali akcaagac <aliakc@web.de>
allan stephens <allan.stephens@windriver.com>
aloisio almeida jr <aloisio.almeida@openbossa.org>
andreas dilger <adilger.kernel@dilger.ca>
andreas koensgen <ajk@comnets.uni-bremen.de>
andrew hendry <andrew.hendry@gmail.com>
andrew veliath <andrewtv@usa.net>
andries brouwer <aeb@cwi.nl>
andy henroid <andrew.d.henroid@intel.com>
anil ravindranath <anil_ravindranath@pmc-sierra.com>
anil s keshavamurthy <anil.s.keshavamurthy@intel.com>
antoine jacquet <royale@zerezo.com>
antonino daplas <adaplas@gmail.com>
armin schindler <mac@melware.de>
artur paszkiewicz <artur.paszkiewicz@intel.com>
"arvind r." <arvino55@gmail.com>
ashley lai <ashley@ashleylai.com>
aurelien jacquiot <a-jacquiot@ti.com>
balbir singh <bsingharora@gmail.com>
bill metzenthen <billm@melbpc.org.au>
bradley grove <linuxdrivers@attotech.com>
brett rudley <brudley@broadcom.com>
brian johnson <brijohn@gmail.com>
bruce chang <brucechang@via.com.tw>
bryan huntsman <bryanh@codeaurora.org>
ceph-devel@vger.kernel.org
cesar miquel <miquel@df.uba.ar>
cezary jackiewicz <cezary.jackiewicz@gmail.com>
chaoming li <chaoming_li@realsil.com.cn>
chen liqin <liqin.linux@gmail.com>
chien yen <chien.yen@oracle.com>
chirag kantharia <chirag.kantharia@hp.com>
chris brannon <chris@the-brannons.com>
christine caulfield <ccaulfie@redhat.com>
christopher harrer <charrer@alacritech.com>
"christopher li" <sparse@chrisli.org>
christoph raisch <raisch@de.ibm.com>
cliff whickman <cpw@sgi.com>
colin leroy <colin@colino.net>
corentin labbe <clabbe.montjoie@gmail.com>
daniel drake <dsd@gentoo.org>
daniele venzano <venza@brownhat.org>
daniel oliveira nascimento <don@syst.com.br>
daniel ribeiro <drwyrm@gmail.com>
dario ballabio <ballabio_dario@emc.com>
david kershner <david.kershner@unisys.com>
david rowe <david@rowetel.com>
david safford <safford@us.ibm.com>
david täht <d@teklibre.com>
deepak saxena <dsaxena@plexity.net>
dirk eibach <eibach@gdsys.de>
dirk opfer <dirk@opfer-online.de>
dmitry tarnyagin <dmitry.tarnyagin@lockless.no>
dominik brodowski <linux@dominikbrodowski.net>
doug gilbert <dgilbert@interlog.com>
doug thompson <dougthompson@xmission.com>
doug warzecha <douglas_warzecha@dell.com>
duncan sands <duncan.sands@free.fr>
"ed l. cashin" <ecashin@coraid.com>
egor martovetsky <egor@pasemi.com>
eric biederman <ebiederm@xmission.com>
eric piel <eric.piel@tremplin-utc.net>
erik andren <erik.andren@gmail.com>
faisal latif <faisal.latif@intel.com>
ferenc bakonyi <fero@drama.obuda.kando.hu>
florian schilhabel <florian.c.schilhabel@googlemail.com>.
forest bond <forest@alittletooquiet.net>
frank seidel <frank@f-seidel.de>
fujita tomonori <fujita.tomonori@lab.ntt.co.jp>
gary zambrano <zambrano@broadcom.com>
gilles muller <gilles.muller@lip6.fr>
gleb natapov <gleb@kernel.org>
guillaume ligneul <guillaume.ligneul@gmail.com>
guo-fu tseng <cooldavid@cooldavid.org>
gustavo padovan <gustavo@padovan.org>
haavard skinnemoen <hskinnemoen@gmail.com>
hal rosenstock <hal.rosenstock@gmail.com>
hansjoerg lipp <hjlipp@web.de>
hans ulli kroll <ulli.kroll@googlemail.com>
harald welte <haraldwelte@viatech.com>
harald welte <laforge@openezx.org>
henk vergonet <henk.vergonet@gmail.com>
henrique de moraes holschuh <ibm-acpi@hmh.eng.br>
herton ronaldo krzesinski <herton@canonical.com>
heungjun kim <riverful.kim@samsung.com>
hideaki yoshifuji <yoshfuji@linux-ipv6.org>
hoang-nam nguyen <hnguyen@de.ibm.com>
hubert feurstein <hubert.feurstein@contec.at>
"hung hing lun, mike" <hlhung3i@gmail.com>
ian campbell <ijc+devicetree@hellion.org.uk>
ian molton <spyro@f2s.com>
ion badulescu <ionut@badula.org>
ishizaki kou <kou.ishizaki@toshiba.co.jp>
ivan kokshaysky <ink@jurassic.park.msu.ru>
jakub schmidtke <sjakub@gmail.com>
"james e.j. bottomley" <james.bottomley@hansenpartnership.com>
"james e.j. bottomley" <jbottomley@parallels.com>
"james e.j. bottomley" <jejb@parisc-linux.org>
james morris <jmorris@namei.org>
"james r. van zandt" <jrv@vanzandt.mv.com>
jamie lenehan <lenehan@twibble.org>
jan-benedict glaw <jbglaw@lug-owl.de>
jan dumon <j.dumon@option.com>
jan harkes <jaharkes@cs.cmu.edu>
jan-simon moeller <jansimon.moeller@gmx.de>
jarkko lavinen <jarkko.lavinen@nokia.com>
jarod wilson <jarod@wilsonet.com>
jason uhlenkott <juhlenko@akamai.com>
jaya kumar <jayakumar.alsa@gmail.com>
jaya kumar <jayalk@intworks.biz>
jay cliburn <jcliburn@gmail.com>
jean-paul roubelat <jpr@f6fbb.org>
jeff dike <jdike@addtoit.com>
jens osterkamp <jens@de.ibm.com>
jes sorensen <jes@trained-monkey.org>
jim paris <jim@jtan.com>
jiri kosina <trivial@kernel.org>
jiri slaby <jirislaby@gmail.com>
joerg reuter <jreuter@yaina.de>
joern engel <joern@lazybastard.org>
johan hedberg <johan.hedberg@gmail.com>
john mccutchan <john@johnmccutchan.com>
john ronciak <john.ronciak@intel.com>
"john w. linville" <linville@tuxdriver.com>
jonathan buzzard <jonathan@buzzard.org.uk>
"jon d. mason" <jdmason@kudzu.us>
jon nettleton <jon.nettleton@gmail.com>
josh triplett <josh@freedesktop.org>
joshua morris <josh.h.morris@us.ibm.com>
joshua thompson <funaho@jurai.org>
juanjo ciarlante <jjciarla@raiz.uncu.edu.ar>
"juergen e. fischer" <fischer@norbit.de>
juergen stuber <starblue@users.sourceforge.net>
juerg haefliger <juergh@gmail.com>
kentaro takeda <takedakn@nttdata.co.jp>
kevin curtis <kevin.curtis@farsite.co.uk>
kevin hilman <khilman@kernel.org>
kirk reiser <kirk@reisers.ca>
koichi yasutake <yasutake.koichi@jp.panasonic.com>
kristoffer glembo <kristoffer@gaisler.com>
kurt garloff <garloff@suse.de>
leandro costantino <lcostantino@gmail.com>
len brown <lenb@kernel.org>
lennert buytenhek <kernel@wantstofly.org>
liam girdwood <lgirdwood@gmail.com>
liam girdwood <lrg@slimlogic.co.uk>
lior dotan <liodot@gmail.com>
"luis r. rodriguez" <mcgrof@gmail.com>
maik broemme <mbroemme@plusserver.de>
manohar vanga <manohar.vanga@gmail.com>
marcelo henrique cerri <mhcerri@linux.vnet.ibm.com>
marc hulsman <m.hulsman@tudelft.nl>
"mark f. brown" <mark.brown314@gmail.com>
martin mares <mj@ucw.cz>
matthew wilcox <matthew@wil.cx>
matt mackall <mpm@selenic.com>
maxim krasnyansky <maxk@qti.qualcomm.com>
michael hanselmann <linux-kernel@hansmi.ch>
michael petchkovsky <mkpetch@internode.on.net>
michael reed <mdr@sgi.com>
michal januszewski <spock@gentoo.org>
michal ostrowski <mostrows@earthlink.net>
miguel ojeda sandonis <miguel.ojeda.sandonis@gmail.com>
mikael starvik <starvik@axis.com>
mike marciniszyn <infinipath@intel.com>
mike rapoport <mike@compulab.co.il>
miloslav trmac <mitr@volny.cz>
miroslav zagorac <zaga@fly.cc.fer.hr>
mitchell blank jr <mitch@sfgoth.com>
muli ben-yehuda <muli@il.ibm.com>
nagalakshmi nandigama <nagalakshmi.nandigama@avagotech.com>
neela syam kolli <megaraidlinux@lsi.com>
nelson castillo <arhuaco@freaks-unidos.net>
nicholas a. bellinger <nab@linux-iscsi.org>
nick piggin <npiggin@kernel.dk>
olav kongas <ok@artecdesign.ee>
olivier lorin <o.lorin@laposte.net>
pantelis antoniou <pantelis.antoniou@gmail.com>
pat gefre <pfg@sgi.com>
paul mackerras <paulus@au.ibm.com>
pau oliva fora <pof@eslack.org>
peter chubb <pleb@gelato.unsw.edu.au>
peter feuerer <peter@piie.net>
philip blundell <philb@gnu.org>
philip kelleher <pjk1939@linux.vnet.ibm.com>
philip moltmann <moltmann@vmware.com>
praveen krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
rakesh iyer <riyer@nvidia.com>
ranganathan desikan <ravi@jetztechnologies.com>
remi denis-courmont <courmisch@gmail.com>
riccardo facchetti <fizban@tin.it>
richard l maliszewski <richard.l.maliszewski@intel.com>
"richard russon (flatcap)" <ldm@flatcap.org>
rik faith <faith@cs.unc.edu>
robert gerlach <khnz@gmx.de>
robert love <rlove@rlove.org>
robert love <rml@tech9.net>
rob herring <robh+dt@kernel.org>
roland dreier <roland@kernel.org>
roland mcgrath <roland@redhat.com>
ron mercer <ron.mercer@qlogic.com>
ron minnich <rminnich@sandia.gov>
samuel chessman <chessman@tux.org>
santosh raspatur <santosh@chelsio.com>
scott murray <scott@spiteful.org>
sergey lapin <slapin@ossfans.org>
shane wang <shane.wang@intel.com>
simon arlott <cxacru@fire.lp0.eu>
simon kelley <simon@thekelleys.org.uk>
sorbica shieh <sorbica@icplus.com.tw>
srinivas kandagatla <srinivas.kandagatla@gmail.com>
stefan eletzhofer <stefan.eletzhofer@eletztrick.de>
stefano brivio <stefano.brivio@polimi.it>
steve french <sfrench@samba.org>
steve sakoman <sakoman@gmail.com>
steve underwood <steveu@coppice.org>
steve wise <swise@chelsio.com>
subbu seetharaman <subbu.seetharaman@emulex.com>
sudarsana kalluru <sudarsana.kalluru@qlogic.com>
sujith thomas <sujith.thomas@intel.com>
teddy wang <teddy.wang@siliconmotion.com.cn>
terje bergström <tbergstrom@nvidia.com>
thibaut varene <t-bone@parisc-linux.org>
thomas dahlmann <dahlmann.thomas@arcor.de>
thomas winischhofer <thomas@winischhofer.net>
"tigran a. aivazian" <tigran@aivazian.fsnet.co.uk>
tigran aivazian <tigran@aivazian.fsnet.co.uk>
till harbaum <till@harbaum.org>
tim small <tim@buttersideup.com>
tim waugh <tim@cyberelk.net>
tony finch <dot@dotat.at>
tony olech <tony.olech@elandigitalsystems.com>
torben mathiasen <device@lanana.org>
ulrich kunitz <kune@deine-taler.de>
vegard nossum <vegardno@ifi.uio.no>
ville syrjala <syrjala@sci.fi>
vishwas a deshpande <vishwas.a.deshpande@ti.com>
vitaly bordug <vbordug@ru.mvista.com>
vitaly bordug <vitb@kernel.crashing.org>
wensong zhang <wensong@linux-vs.org>
willem riede <osst@riede.org>
willy tarreau <willy@meta-x.org>
"wong hoi sing, edison" <hswong3i@gmail.com>
xavier deguillard <xdeguillard@vmware.com>
yokota hiroshi <yokota@netlab.is.tsukuba.ac.jp>
zhang wei <zw@zh-kernel.org>
zwane mwaikambo <zwanem@gmail.com>


