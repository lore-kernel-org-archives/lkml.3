Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaHHGxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:53:01 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:3795
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752258AbaHHGw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:52:59 -0400
Date: Fri, 8 Aug 2014 14:42:43 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH V4 0/2]  refine esai for tdm support
Message-ID: <20140808064243.GA6333@MrMyself>
References: <cover.1407480333.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1407480333.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199002)(189002)(24454002)(47776003)(97736001)(81342001)(87936001)(50466002)(99396002)(44976005)(92566001)(85852003)(33656002)(79102001)(77982001)(20776003)(15975445006)(33716001)(97756001)(46102001)(76176999)(68736004)(50986999)(15202345003)(19580395003)(19580405001)(81542001)(83506001)(83322001)(54356999)(76482001)(95666004)(80022001)(21056001)(26826002)(23726002)(105606002)(104016003)(102836001)(64706001)(92726001)(83072002)(110136001)(6806004)(74662001)(74502001)(85306004)(107046002)(46406003)(84676001)(86362001)(106466001)(31966008)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB329;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 02:47:20PM +0800, Shengjiu Wang wrote:
> These patchs is to refine esai for tdm support.
> 
> Changes for V4
> - update the comments for patch 2
> 
> Changes for V3
> - update the comments for patch 2
> 
> Changes for V2
> - update the comments according the reviewer's suggestion
> - add init value for slots and change pin to pins.
> 
> 
> Shengjiu Wang (2):
>   ASoC: fsl_esai: refine esai for TDM support
>   Revert "ASoC: fsl-esai: Add .xlate_tdm_slot_mask() support."
> 
>  sound/soc/fsl/Kconfig    |    1 -
>  sound/soc/fsl/fsl_esai.c |   16 +++++++++++-----
>  sound/soc/fsl/fsl_esai.h |    8 ++++----
>  3 files changed, 15 insertions(+), 10 deletions(-)

Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>

Thank you

> 
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
