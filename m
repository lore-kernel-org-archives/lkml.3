Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaDXXGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:06:47 -0400
Received: from mail-bl2on0127.outbound.protection.outlook.com ([65.55.169.127]:3258
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325AbaDXXGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:06:45 -0400
Message-ID: <1398379746.14881.3.camel@linux-builds1>
Subject: Re: socfpga in 3.15-rc2
From: Dinh Nguyen <dinguyen@altera.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>, <dinh@amd.pavel.ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Thu, 24 Apr 2014 17:49:06 -0500
In-Reply-To: <20140424152156.GA22540@amd.pavel.ucw.cz>
References: <20140424125421.GA19526@amd.pavel.ucw.cz>
	 <734n1i25ad.fsf@unicorn.hi.pengutronix.de>
	 <20140424152156.GA22540@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(377424004)(51704005)(199002)(24454002)(74662001)(31966008)(44976005)(6806004)(74502001)(46102001)(4396001)(80022001)(23676002)(81542001)(50226001)(81342001)(62966002)(93916002)(80976001)(92566001)(77156001)(92726001)(77982001)(89996001)(88136002)(33646001)(47776003)(20776003)(79102001)(76482001)(87286001)(33716001)(87936001)(76176999)(83072002)(85852003)(50986999)(2009001)(86362001)(19580395003)(83322001)(19580405001)(97736001)(84676001)(50466002)(99396002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB041;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:231E706C.5D930289.B6F5109A.B3CCF7F9.20117;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 01917B1794
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 17:21 +0200, Pavel Machek wrote:
> Hi!
> 
> > > Does socfpga boot for you on 3.15-rc2? Mainline worked on 3.14 pretty
> > > well, but I get no output from serial from 3.15-rc2. Any ideas?
> > >
> > 
> > You need:
> > 
> > [PATCH] clk: socfpga: fix clock driver for 3.15
> > Message-Id: 1397481336-5592-1-git-send-email-dinguyen@altera.com
> 
> Thanks a lot, with that patch, I'm back to working system.

Glad you found it. Who's dinh@amd.pavel.ucw.cz?

Dinh
> 
> 									Pavel


