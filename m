Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaBSLOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:14:17 -0500
Received: from f243.i.mail.ru ([94.100.178.218]:39837 "EHLO f243.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaBSLOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:14:15 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWljaGFsIFNpbWVr?= <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        =?UTF-8?B?TWljaGFsIFNpbWVr?= <monstr@monstr.eu>,
        =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtSRkMgUEFUQ0ggdjIgMS8yXSBtZmQ6IHN5c2NvbjogU3VwcG9ydCBl?=
 =?UTF-8?B?YXJseSBpbml0aWFsaXphdGlvbg==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Wed, 19 Feb 2014 15:14:09 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1392808449.306481065@f243.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com>
References: <cover.1392807832.git.michal.simek@xilinx.com>
 <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1JBEcsG005254

Ğ¡Ñ€ĞµĞ´Ğ°, 19 Ñ„ĞµĞ²Ñ€Ğ°Ğ»Ñ 2014, 12:04 +01:00 Ğ¾Ñ‚ Michal Simek <michal.simek@xilinx.com>:
> Some platforms need to get system controller
> ready as soon as possible.
> The patch provides early_syscon_initialization
> which create early mapping for all syscon compatible
> devices in early_syscon_probe.
> Regmap is get via syscon_early_regmap_lookup_by_phandle()
> 
> Regular device probes attach device to regmap
> via regmap_attach_dev().
> 
> For early syscon initialization is necessary to extend
> struct syscon and provide remove function
> which unmap all early init structures.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
...

> +static struct of_device_id of_syscon_ids[] = {
> +	{ .compatible = "syscon" },
> +	{},
>  };

You should move syscon_ids out of #ifdef CONFIG_OF

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
