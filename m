Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaILQ0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:26:18 -0400
Received: from fallback4.mail.ru ([94.100.181.169]:45931 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaILQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:26:14 -0400
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 12:26:13 EDT
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG1pdHJ5IExhdm5pa2V2aWNo?= 
	<d.lavnikevich@sam-solutions.com>
Cc: =devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shawn.guo@freescale.com, kernel@pengutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, perex@perex.cz, tiwai@suse.de
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAyLzRdIEFSTTogZHRzOiBwYmFiMDE6IGVuYWJsZSBJ?=
 =?UTF-8?B?MlMgYXVkaW8gb24gcGh5RkxFWC1pLk1YNiBib2FyZHM=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.7]
Date: Fri, 12 Sep 2014 20:14:46 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1410538486.406482403@f174.i.mail.ru>
X-Cloud-Ids: 
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1410537872-17274-3-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1410537872-17274-3-git-send-email-d.lavnikevich@sam-solutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8CGQMv3002496

Fri, 12 Sep 2014 19:04:30 +0300 Ğ¾Ñ‚ Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>:
> Audio on phyFLEX boards is presented by tlv320aic3007 codec connected
> over SSI interface.
> 
> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> ---
...
> +&audmux {
> +	status = "okay";
> +
> +	ssi2 {
> +		fsl,audmux-port = <1>;
> +		fsl,port-config = <0xa5000000 0x00008000>;
> +	};
> +	pins5 {
> +		fsl,audmux-port = <4>;
> +		fsl,port-config = <0x00000000 0x00002000>;
> +	};
> +};

You should use defines from sound/fsl-imx-audmux.h for audmux.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
