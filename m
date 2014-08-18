Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaHRHgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 03:36:07 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:47894
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbaHRHgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 03:36:05 -0400
Date: Mon, 18 Aug 2014 15:35:56 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
CC: <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] pinctrl: imx*: Make of_device_id array const
Message-ID: <20140818073555.GA2404@dragon>
References: <1407771277-19477-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1407771277-19477-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130528209619096922;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009005)(6009001)(448002)(189002)(51704005)(199003)(24454002)(97756001)(81542001)(110136001)(46406003)(102836001)(23726002)(87936001)(21056001)(76176999)(83506001)(54356999)(97736001)(81342001)(68736004)(57986006)(50466002)(33656002)(77982001)(64706001)(104016003)(31966008)(46102001)(20776003)(19580395003)(44976005)(74502001)(80022001)(50986999)(85852003)(95666004)(85306004)(86362001)(85326001)(106466001)(84676001)(19580405001)(92726001)(74662001)(79102001)(107046002)(92566001)(33716001)(4396001)(26826002)(83072002)(47776003)(83322001)(6806004)(76482001)(99396002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB361;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=permerror (sender IP is 192.88.168.50)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 09:04:26PM +0530, Kiran Padwal wrote:
> Kiran Padwal (11):
>   pinctrl: imx23: Make of_device_id array const
>   pinctrl: imx25: Make of_device_id array const
>   pinctrl: imx27: Make of_device_id array const
>   pinctrl: imx28: Make of_device_id array const
>   pinctrl: imx35: Make of_device_id array const
>   pinctrl: imx50: Make of_device_id array const
>   pinctrl: imx51: Make of_device_id array const
>   pinctrl: imx53: Make of_device_id array const
>   pinctrl: imx6dl: Make of_device_id array const
>   pinctrl: imx6q: Make of_device_id array const
>   pinctrl: imx6sx: Make of_device_id array const

One patch is probably enough.  Otherwise,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

>  drivers/pinctrl/pinctrl-imx23.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx25.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx27.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx28.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx35.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx50.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx51.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx53.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx6dl.c |    2 +-
>  drivers/pinctrl/pinctrl-imx6q.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx6sx.c |    2 +-
>  11 files changed, 11 insertions(+), 11 deletions(-)
