Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaBLHJt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 12 Feb 2014 02:09:49 -0500
Received: from f237.i.mail.ru ([94.100.178.217]:44605 "EHLO f237.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaBLHJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:09:47 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UGF3ZWwgTW9sbA==?= <pawel.moll@arm.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwNy8xMl0gbWZkOiBzeXNjb246IENvbnNpZGVyIHBsYXRm?=
 =?UTF-8?B?b3JtIGRhdGEgYSByZWdtYXAgY29uZmlnIG5hbWU=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Wed, 12 Feb 2014 11:09:42 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1392188982.914924525@f237.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1392138636-29240-8-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
 <1392138636-29240-8-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s1C79vpo020238

Hello.

Ğ’Ñ‚Ğ¾Ñ€Ğ½Ğ¸Ğº, 11 Ñ„ĞµĞ²Ñ€Ğ°Ğ»Ñ 2014, 17:10 UTC Ğ¾Ñ‚ Pawel Moll <pawel.moll@arm.com>:
> Use the device platform data as a regmap config
> name. This is particularly useful in the regmap
> debugfs when there is more than one syscon device
> registered, to distinguish the register blocks.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
...
> syscon_regmap_config.max_register = res->end - res->start - 3;
> +	syscon_regmap_config.name = dev_get_platdata(&pdev->dev);

Is dev_name(&pdev->dev) can be used for such purpose?

Thanks.
---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
