Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3K2PwY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 29 Nov 2013 10:52:24 -0500
Received: from fallback2.mail.ru ([94.100.176.87]:38368 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3K2PwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:52:22 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWljaGFlbCBHcnplc2NoaWs=?= <m.grzeschik@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        s.nawrocki@samsung.com, kernel@pengutronix.de
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbWZkOiBzeXNjb246IGFkZCBpbmxpbmUgbm9wIGZ1bmN0?=
 =?UTF-8?B?aW9ucyB0byBjb21waWxlIHdpdGhvdXQgb3B0aW9u?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Fri, 29 Nov 2013 19:25:54 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1385738754.218451164@f337.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1385738156-31852-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1385738156-31852-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id rATFqQmv021203

> The syscon interface can be used in different drivers to reach registers
> of other register range via phandle. The exported functions can only be
> used if the syscon interface is enabled. This patch fixes this by
> adding nop functions if the syscon is not selected in the config.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/include/linux/mfd/syscon.h?id=df73de9b0d412915384396637bf67ef9208161e9

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
