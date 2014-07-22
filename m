Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaGVCeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:34:23 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:53430
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751240AbaGVCeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:34:22 -0400
Date: Tue, 22 Jul 2014 10:34:03 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <peter.chen@freescale.com>, <s.hauer@pengutronix.de>,
        <b35083@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] chipidea: usbmisc_imx: Add USB support for VF610 SoCs
Message-ID: <20140722023402.GT8537@dragon>
References: <cover.1405702442.git.stefan@agner.ch>
 <e776c8a6ea0d919edb5e3ce1bf0697b23f09f028.1405702442.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e776c8a6ea0d919edb5e3ce1bf0697b23f09f028.1405702442.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(6029001)(199002)(24454002)(189002)(81542001)(74662001)(97756001)(81342001)(64706001)(47776003)(20776003)(99396002)(74502001)(87936001)(97736001)(84676001)(80022001)(33716001)(68736004)(69596002)(31966008)(83322001)(6806004)(19580395003)(102836001)(44976005)(83506001)(33656002)(86362001)(50986999)(26826002)(21056001)(76176999)(54356999)(23726002)(95666004)(105606002)(81156004)(106466001)(50466002)(4396001)(85306003)(46406003)(85852003)(110136001)(92566001)(92726001)(79102001)(76482001)(104016003)(46102001)(57986006)(107046002)(83072002)(77982001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB465;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:01:40PM +0200, Stefan Agner wrote:
> @@ -283,6 +307,10 @@ static const struct of_device_id usbmisc_imx_dt_ids[] = {
>  		.compatible = "fsl,imx6q-usbmisc",
>  		.data = &imx6q_usbmisc_ops,
>  	},
> +	{
> +		.compatible = "fsl,vf610-usbmisc",

Update Documentation/devicetree/bindings/usb/usbmisc-imx.txt please.

Shawn

> +		.data = &vf610_usbmisc_ops,
> +	},
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, usbmisc_imx_dt_ids);
