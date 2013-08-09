Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967219Ab3HIKvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:51:11 -0400
Received: from fallback7.mail.ru ([94.100.176.135]:47807 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966999Ab3HIKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:51:08 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@kernel.org>
Cc: =?UTF-8?B?V2VpIE5p?= <wni@nvidia.com>, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, MLongnecker@nvidia.com,
        linux-arm-kernel@lists.infradead.org, khali@linux-fr.org,
        =?UTF-8?B?R3VlbnRlciBSb2Vjaw==?= <linux@roeck-us.net>
Subject: =?UTF-8?B?UmU6IFByb3Bvc2FsOiBJMkMgZGV2aWNlIHBvd2VyIChXYXM6IGh3bW9uOiAo?=
 =?UTF-8?B?bG05MCkgQWRkIHBvd2VyIGNvbnRyb2wp?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Fri, 09 Aug 2013 14:50:11 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1376045411.585130456@f141.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <20130809102757.GT6427@sirena.org.uk>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1376027820.695103970@f416.i.mail.ru>
 <20130809102757.GT6427@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r79ApGcv009472

> On Fri, Aug 09, 2013 at 09:57:00AM +0400, Alexander Shiyan wrote:
> 
> > Instead of adding the support of regulators in each device, let's think about
> > whether it is possible to create a global regulator for any device on the I2C bus.
> 
> > I see it like this:
> > We add an extra field in the i2c_board_info structure "power_name" and handle
> > it in the i2c_device_{probe/remove} functions.
> 
> This would need to be an array of supplies, relatively few devices need
> only a single power supply.  This is also not something that should be
> handled in I2C, power is not something that's uniquely needed by devices
> on an I2C bus.

Additional regulators can be handled in the driver, or "parent"-scheme can
be used. Is not it?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
