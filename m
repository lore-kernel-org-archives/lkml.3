Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3COJPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:15:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60966 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3COJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:15:08 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-c2-5142e69b8371
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
In-reply-to: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
Subject: [PATCH 3/6] gpio: max7301: use devm_kzalloc()
Date: Fri, 15 Mar 2013 18:15:06 +0900
Message-id: <006401ce215d$95c565a0$c15030e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXW7HXikowtUaTheLztVYvIsx2AAABw4A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI93Zz5wCDabs4bC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZx1c8ZS/YzVbxd351A+Ns1i5GTg4JAROJ/1f/MkLYYhIX7q1n
	A7GFBJYxSvy8EwtTs/L/BZYuRi6g+CJGiRnTlrFAFM1mkuhbzQdiswmoSXz5cpgdxBYR0JO4
	caEDbCizQJHE865ZrBD1thJHrn8C6+UUsJN4tq4PLC4sYCbR//ETmM0ioCoxrRviIF6g+ou7
	z7JB2IISPybfY4GYqSWxfudxJghbXmLzmrfMXYwcQIeqSzz6qwtxgpHEmpb3rBAlIhL7Xrxj
	BLlfQmAeu0Tb439sELsEJL5NPsQC0SsrsekAM8S/khIHV9xgmcAoMQvJ5llINs9CsnkWkhUL
	GFlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoRE1cQdjPcPWB9iTAZaP5FZSjQ5HxiVeSXx
	hsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg7Nrcdc/T
	kDOgJc+NYZLqdVuHPVHpreLhc0TMZ9atVNddfcwwSTPpdPmNTRO7T7N/yrieNWVde3epR/CC
	+382qrDI5pwQNH076cQO1sW33lvWmK4zfG49WeHo4uwThwQ+zJ0RuCB6QmX8lcMbd1+ebrPt
	/NPTOidTjHsdHr06r5u/NVp17Rqvh0osxRmJhlrMRcWJAF4jLDzAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7sZ06BBks3sVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjOMrnrIX7Gar+Du/uoFx
	NmsXIyeHhICJxMr/F1ggbDGJC/fWs3UxcnEICSxilJgxbRlYQkhgNpNE32o+EJtNQE3iy5fD
	7CC2iICexI0LHYwgNrNAkcTzrlmsEPW2EkeufwLr5RSwk3i2rg8sLixgJtH/8ROYzSKgKjGt
	+y9YLy9Q/cXdZ9kgbEGJH5PvsUDM1JJYv/M4E4QtL7F5zVvmLkYOoEPVJR791YU4wUhiTct7
	VogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GMFR+0x6B+OqBotDjAIcjEo8vA4PHQOFWBPLiitzDzFKcDArifB+vOgUKMSbklhZlVqUH19U
	mpNafIgxGejRicxSosn5wISSVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2MLWo7s9g232nZ+7637oi42/PvE+yu+SW9tmHaJfD5+afZf2YdCA/R/9f3SNu5
	Jokxp9NIwXKTQnfo//qSxkKJhy8+e5+czvkr+6y/XpDjrlf3S49xpYsztDgunMGcduR4ymGn
	e1taZC83H13CJFL5xfv2t8lRzY+P/omsD3gdEv6V6VVDkUiLEktxRqKhFnNRcSIArpvJSh4D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-max7301.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-max7301.c b/drivers/gpio/gpio-max7301.c
index c6c535c..6e1c984 100644
--- a/drivers/gpio/gpio-max7301.c
+++ b/drivers/gpio/gpio-max7301.c
@@ -61,7 +61,7 @@ static int max7301_probe(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
-	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
+	ts = devm_kzalloc(&spi->dev, sizeof(struct max7301), GFP_KERNEL);
 	if (!ts)
 		return -ENOMEM;
 
@@ -70,8 +70,6 @@ static int max7301_probe(struct spi_device *spi)
 	ts->dev = &spi->dev;
 
 	ret = __max730x_probe(ts);
-	if (ret)
-		kfree(ts);
 	return ret;
 }
 
-- 
1.7.2.5


