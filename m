Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3BVKnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:43:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12737 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab3BVKnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:43:02 -0500
X-AuditID: cbfee690-b7f066d00000169f-be-51274bb45b59
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: ams369fg06: convert ams369fg06 to dev_pm_ops
Date: Fri, 22 Feb 2013 19:42:59 +0900
Message-id: <003201ce10e9$61e11b50$25a351f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q6WHJS4caNLWdSOOoYhBmxaMp3g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zQ90t3uqBBntOG1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MrU+PMRd8EajY2fOMvYFxMl8XIyeHhICJxPlz71ggbDGJC/fW
	s3UxcnEICSxjlDh1tokRrmjCcxaIxCJGiVlnJ7JDOLOZJO5/gKhiE1CT+PLlMFCCg0NEQF+i
	rUUDJMwsUCqx9cF7sA3CAh4S07v2s4KUsAioSmxflgwS5hWwleg60c4IYQtK/Jh8jwWiVUti
	/c7jTBC2vMTmNW+ZQVolBNQlHv3VBQmLCOhJ3Js1D6pcRGLfi3eMIJdJCLSzS2z7swQswSIg
	IPFt8iEWiF5ZiU0HmCHekpQ4uOIGywRGsVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchE
	rzgxt7g0L10vOT93EyMkTibsYLx3wPoQYzLQ+onMUqLJ+cA4yyuJNzQ2NjEzMTUxtzQ1NyVN
	WEmcV/6STKCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxsS8lucWZoUqW85MM50wnfF++iPr
	v+KHr03O6Mtcf6dYYvOnHzq2S9YHrvUoCCsWPHiDQVD0/FZvh/We97ZG5p24Iims3Pu4RyFM
	+MGRxxs8LqQY3JrXFlnMcJmvnbnzlm7blmnrSh3DZ60OPtT6k4vBatHuqKY/SXfNk49NX1S1
	1O7hog3xnkosxRmJhlrMRcWJAIA+mD+pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd3N3uqBBh8XGFpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjK1PjzEXfBGo2NnzjL2B
	cTJfFyMnh4SAicT5Cc9ZIGwxiQv31rN1MXJxCAksYpSYdXYiO4Qzm0ni/ocmRpAqNgE1iS9f
	DgMlODhEBPQl2lo0QMLMAqUSWx+8BxskLOAhMb1rPytICYuAqsT2ZckgYV4BW4muE+2MELag
	xI/J91ggWrUk1u88zgRhy0tsXvOWGaRVQkBd4tFfXZCwiICexL1Z86DKRST2vXjHOIFRYBaS
	SbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH4TOpHYwrGywOMQpw
	MCrx8Da4qAUKsSaWFVfmHmKU4GBWEuE1sFAPFOJNSaysSi3Kjy8qzUktPsSYDPTnRGYp0eR8
	YILIK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2MgrO69d7M
	LN/rWRnTJPYvK67KwtT5m7ChlqcEx7vk8sxTyr9u3uAKcUzb6hH9gdNj3lnVsDSfGM7N8Zfz
	XA2NZHNMi4+VPdy6ZZfE908L5HfNPZR303ZrasaVWU5fbSZfDiiZHyonVnhMvI3TPeLkvf+p
	7s4tacKfNBc/yblYsOvqk2CG3+uUWIozEg21mIuKEwE0B2SmBgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index c02aa2c..505d446 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -534,11 +534,11 @@ static int ams369fg06_remove(struct spi_device *spi)
 }
 
 #if defined(CONFIG_PM)
-static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
+static int ams369fg06_suspend(struct device *dev)
 {
-	struct ams369fg06 *lcd = spi_get_drvdata(spi);
+	struct ams369fg06 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -547,17 +547,17 @@ static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 	return ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int ams369fg06_resume(struct spi_device *spi)
+static int ams369fg06_resume(struct device *dev)
 {
-	struct ams369fg06 *lcd = spi_get_drvdata(spi);
+	struct ams369fg06 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return ams369fg06_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define ams369fg06_suspend	NULL
-#define ams369fg06_resume	NULL
+
+static SIMPLE_DEV_PM_OPS(ams369fg06_pm_ops, ams369fg06_suspend,
+			ams369fg06_resume);
 #endif
 
 static void ams369fg06_shutdown(struct spi_device *spi)
@@ -571,12 +571,13 @@ static struct spi_driver ams369fg06_driver = {
 	.driver = {
 		.name	= "ams369fg06",
 		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &ams369fg06_pm_ops,
+#endif
 	},
 	.probe		= ams369fg06_probe,
 	.remove		= ams369fg06_remove,
 	.shutdown	= ams369fg06_shutdown,
-	.suspend	= ams369fg06_suspend,
-	.resume		= ams369fg06_resume,
 };
 
 module_spi_driver(ams369fg06_driver);
-- 
1.7.2.5


