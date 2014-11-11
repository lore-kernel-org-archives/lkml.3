Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaKKDAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:00:24 -0500
Received: from mail-bn1on0072.outbound.protection.outlook.com ([157.56.110.72]:56384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751293AbaKKDAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:00:22 -0500
Message-ID: <1415674805.2445.0.camel@leyfoon-vm>
Subject: Re: [PATCH v6 00/29] nios2 Linux kernel port
From: Ley Foon Tan <lftan@altera.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Date: Tue, 11 Nov 2014 11:00:05 +0800
In-Reply-To: <20141110001250.7fc64233@canb.auug.org.au>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
	 <CAFiDJ5_6HOPH_g6+Z1GwE87qXaGtnyUZdPvFCbC7E3v0+7o3VA@mail.gmail.com>
	 <CAFiDJ5_opOE5g14y1A7X3mn3H0ZOGV0kLVhEJnSrt3n47Nn2bQ@mail.gmail.com>
	 <20141110001250.7fc64233@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(377454003)(52604005)(51704005)(52034003)(24454002)(199003)(377424004)(189002)(50986999)(89996001)(87936001)(15975445006)(87286001)(68736004)(44976005)(88136002)(6806004)(84676001)(19580395003)(19580405001)(42186005)(4396001)(50226001)(102836001)(103116003)(76176999)(15202345003)(104166001)(99396003)(50466002)(97736003)(110136001)(21056001)(120916001)(106466001)(105596002)(107046002)(77096003)(77156002)(62966003)(33646002)(95666004)(31966008)(64706001)(33716001)(575784001)(23676002)(86362001)(93916002)(46102003)(20776003)(47776003)(93886004)(92566001)(92726001)(7099021)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB209;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB209;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB209;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB209;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Isn, 2014-11-10 at 00:12 +1100, Stephen Rothwell wrote:
> Hi,
> 
> On Fri, 7 Nov 2014 17:24:43 +0800 Ley Foon Tan <lftan@altera.com> wrote:
> >
> > On Fri, Nov 7, 2014 at 3:39 PM, LF.Tan <lftan.linux@gmail.com> wrote:
> > >
> > > Review for Nios2 port is completed and ready for upstream. Can you
> > > please add nios2 patchset to linux-next?
> > >
> > > The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:
> > >
> > >   Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)
> > >
> > > are available in the git repository at:
> > >
> > >   http://git.rocketboards.org/linux-socfpga-next.git tags/nios2-for-linux-next
> > >
> > > for you to fetch changes up to 1b9e67a57ac633f407de11b36d8f996c368a8c66:
> > >
> > >   nios2: Build infrastructure (2014-11-06 15:23:37 +0800)
> >
> > By the way, I also created "nios2-next" branch for you to add to linux-next.
> > 
> > git://git.rocketboards.org/linux-socfpga-next.git nios2-next
> 
> Added from Monday with just you as the contact.
> 
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window. 
> 
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
>         Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and 
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
Thanks. Saw it in linux-next.

Regards
Ley Foon



