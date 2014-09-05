Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaIEAnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:43:39 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:4467
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751106AbaIEAni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:43:38 -0400
Date: Fri, 5 Sep 2014 08:43:23 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Fancy Fang <chen.fang@freescale.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: clk-imx6sl: correct the pxp and epdc axi clock
 selections
Message-ID: <20140905004322.GE10809@dragon>
References: <1409819592-31462-1-git-send-email-chen.fang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409819592-31462-1-git-send-email-chen.fang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(24454002)(51704005)(81542001)(102836001)(33656002)(83506001)(83322001)(105606002)(50466002)(20776003)(47776003)(76482001)(79102001)(110136001)(107046002)(77982001)(106466001)(19580395003)(46102001)(97736001)(85852003)(104016003)(92566001)(57986006)(44976005)(97756001)(31966008)(54356999)(50986999)(68736004)(99396002)(76176999)(92726001)(6806004)(19580405001)(86362001)(83072002)(23726002)(21056001)(33716001)(46406003)(84676001)(74662001)(74502001)(85306004)(81342001)(80022001)(95666004)(26826002)(90102001)(64706001)(4396001)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB551;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 0325F6C77B
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 04:33:12PM +0800, Fancy Fang wrote:
> The parent clocks of IMX6SL_CLK_PXP_AXI_SEL and IMX6SL_CLK_EPDC_AXI_SEL
> clocks are not the same. So split the epdc_pxp_sels into two different
> clock selections 'pxp_axi_sels' and 'epdc_axi_sels'.
> 
> Signed-off-by: Fancy Fang <chen.fang@freescale.com>
> Signed-off-by: Robby Cai <R63905@freescale.com>

Applied, thanks.
