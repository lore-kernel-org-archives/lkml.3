Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaILCBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:01:33 -0400
Received: from mail-by2on0125.outbound.protection.outlook.com ([207.46.100.125]:22276
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751767AbaILCBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:01:31 -0400
Date: Fri, 12 Sep 2014 10:01:12 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>, <mpa@pengutronix.de>
CC: <timur@tabi.org>, <Li.Xiubo@freescale.com>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140912020110.GA414@audiosh1>
References: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
 <20140911225737.GA13926@Alpha>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140911225737.GA13926@Alpha>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(35774003)(24454002)(52314003)(51704005)(84676001)(50466002)(68736004)(4396001)(46102001)(46406003)(95666004)(31966008)(83506001)(74502001)(74662001)(21056001)(87936001)(107046002)(85306004)(77982001)(97736003)(76482001)(33656002)(105606002)(106466001)(54356999)(6806004)(47776003)(85852003)(76176999)(83072002)(79102001)(92566001)(92726001)(102836001)(86362001)(50986999)(80022001)(83322001)(44976005)(20776003)(64706001)(26826002)(81542001)(97756001)(23726002)(81342001)(33716001)(104016003)(99396002)(90102001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0621;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 03:57:37PM -0700, Nicolin Chen wrote:
> On Thu, Sep 11, 2014 at 01:38:29PM +0800, Shengjiu Wang wrote:
> > Move the ipg clock enable and disable operation to startup and shutdown,
> > that is only enable ipg clock when ssi is working. Keep clock is disabled
> > when ssi is in idle.
> > otherwise, _fsl_ssi_set_dai_fmt function need to be called in probe,
> > so add ipg clock control for it.
> 
> It seems to be no objection so far against my last suggestion to
> use regmap's mmio_clk() for named ipg clk only. So you may still
> consider about that.
>
I think mmio_clk() can be put to another patch. and this patch only for clk_enable()
and clk_disable() operation.
 
> Anyway, I'd like to do thing in parallel. So I just simply tested
> it on my side and its works fine, it may still need to be tested
> by others though.
> 
> Nicolina

Hi Markus

could you please review it, and share your comments?

wang shengjiu
