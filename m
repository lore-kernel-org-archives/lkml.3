Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbaDXWu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:50:29 -0400
Received: from mail-bl2on0125.outbound.protection.outlook.com ([65.55.169.125]:10478
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754121AbaDXWuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:50:23 -0400
Message-ID: <1398379669.14881.2.camel@linux-builds1>
Subject: Re: [PATCH] clk: socfpga: fix clock driver for 3.15
From: Dinh Nguyen <dinguyen@altera.com>
To: ZY - pavel <pavel@denx.de>, <mturquette@linaro.org>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Thu, 24 Apr 2014 17:47:49 -0500
In-Reply-To: <20140424152133.GA23032@amd.pavel.ucw.cz>
References: <1397481336-5592-1-git-send-email-dinguyen@altera.com>
	 <20140424152133.GA23032@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(377424004)(51704005)(199002)(24454002)(164054003)(41574002)(74662001)(31966008)(44976005)(6806004)(74502001)(46102001)(4396001)(80022001)(23676002)(81542001)(50226001)(81342001)(62966002)(93916002)(80976001)(92566001)(77156001)(92726001)(77982001)(89996001)(88136002)(33646001)(47776003)(20776003)(79102001)(76482001)(87286001)(33716001)(87936001)(76176999)(83072002)(85852003)(50986999)(2009001)(86362001)(19580395003)(83322001)(19580405001)(97736001)(84676001)(50466002)(99396002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB029;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:EE82F365.9ED29D01.31793D07.CEEECCA0.2018E;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 01917B1794
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, 2014-04-24 at 17:21 +0200, ZY - pavel wrote:
> Hi!
> 
> > commit [1771b10d6 clk: respect the clock dependencies in of_clk_init]
> > exposed a flaw in the socfpga clock driver and prevents the platform
> > from booting on 3.15-rc1.
> > 
> > Because the "altr,clk-mgr" is not really a clock, it should not be using
> > CLK_OF_DECLARE, instead we should be mapping the clk-mgr's base address
> > one of the functional clock init function. Use the socfpga_pll_init function
> > to map the clk_mgr_base_addr as this clock should always be initialized first.
> > 
> > Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
> 
> Works for me, thanks!
> 									Pavel
> 
> Tested-by: Pavel Machek <pavel@denx.de>
> 

I'm hoping you can queued this up for one of the 3.15-rc.

Thanks,
Dinh


