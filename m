Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaJNJQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:16:42 -0400
Received: from mail-bn1bon0146.outbound.protection.outlook.com ([157.56.111.146]:6944
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751343AbaJNJQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:16:41 -0400
Message-ID: <1413278182.2878.8.camel@aoeu.buserror.net>
Subject: Re: [PATCH v3 00/21] powerpc/8xx: Optimise MMU TLB handling and add
 support of 16k pages
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 14 Oct 2014 11:16:22 +0200
In-Reply-To: <543C0176.5050706@c-s.fr>
References: <20140917163656.E09D81AB026@localhost.localdomain>
	 <1410972043.24184.532.camel@snotra.buserror.net> <5419F017.8010603@c-s.fr>
	 <1410986079.24184.534.camel@snotra.buserror.net> <543C0176.5050706@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [62.156.150.204]
X-ClientProxiedBy: AM3PR05CA039.eurprd05.prod.outlook.com (10.141.192.49) To
 DM2PR0301MB0734.namprd03.prod.outlook.com (25.160.97.142)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0734;
X-Forefront-PRVS: 03648EFF89
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(377424004)(24454002)(199003)(51704005)(479174003)(189002)(50466002)(76482002)(23676002)(104166001)(92566001)(92726001)(40100003)(42186005)(86362001)(77156001)(87286001)(87976001)(107046002)(31966008)(85306004)(95666004)(105586002)(88136002)(89996001)(77096002)(4396001)(93886004)(80022003)(97736003)(46102003)(64706001)(66066001)(120916001)(21056001)(99396003)(101416001)(33646002)(85852003)(50986999)(122386002)(103116003)(76176999)(62966002)(106356001)(102836001)(20776003)(19580405001)(110136001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0734;H:[10.150.145.61];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 18:44 +0200, leroy christophe wrote:
> Le 17/09/2014 22:34, Scott Wood a écrit :
> > On Wed, 2014-09-17 at 22:33 +0200, christophe leroy wrote:
> >> Le 17/09/2014 18:40, Scott Wood a écrit :
> >>> On Wed, 2014-09-17 at 18:36 +0200, Christophe Leroy wrote:
> >>>> This patchset:
> >>>> 1) provides several MMU TLB handling optimisation on MPC8xx.
> >>>> 2) adds support of 16k pages on MPC8xx.
> >>>> All changes have been successfully tested on a custom board equipped with MPC885
> >>>>
> >>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>>> Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>> I've already applied patches 1, 2, 4, 5, 6, 9, and 10 from the previous
> >>> patchset -- have they changed?
> >>>
> >>> -Scott
> >>>
> >> No, only 3, 7, 17 are changed, and 20,21 are new.
> >> I didn't notice you already applied some. How should I then proceed now
> >> for the remaining ones ? Submit a new set ?
> >>
> > No, I'll just skip the ones I've already applied.
> >
> >
> I think I took into account all Joakim's and your's comments in v4.
> Since I submitted v4, I think I didn't get any new comment.
> What's the way forward to get the remaining ones applied ?

I haven't had a chance to review v4 yet.  I'm currently at conferences
and will be on vacation next week, but I will try to look at them soon
after that.

-Scott


