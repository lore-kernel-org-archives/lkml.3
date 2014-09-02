Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaIBP0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:26:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60788 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIBP0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:26:46 -0400
X-AuditID: cbfee690-f79ce6d00000115a-a5-5405e1b3f30f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-serial@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] tty/serial: fix config dependencies for samsung serial
Date: Tue, 02 Sep 2014 20:52:00 +0530
Message-id: <1409671320-7604-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWyRsSkWnfzQ9YQg6efbCyaF69ns9j0+Bqr
	xeVdc9gsZpzfx2RxZnEvu8Wibf+ZLRZt/cLuwO6xc9Zddo/9c9ewe2xeUu/Rt2UVo8fnTXIB
	rFFcNimpOZllqUX6dglcGbsX32UvOMdRsfzcTLYGxqnsXYycHBICJhK7eqcyQdhiEhfurWcD
	sYUEljJKtE+sh6m5P/EjK0R8EaPE4b9iXYxcQHY/k8S6k0uZQRJsAmYSBxetBhsqIqAg8abl
	JTNIEbPAU0aJy8dWgU0VFnCXuPPwJNAkDg4WAVWJhxvlQMK8Ai4Su5fOZwcJSwD1zplkA9Iq
	IfCfTWL5uj6wmSwCAhLfJh9igaiRldh0gBniNkmJgytusExgFFzAyLCKUTS1ILmgOCm9yESv
	ODG3uDQvXS85P3cTIzBgT/97NmEH470D1ocYBTgYlXh4JX6whAixJpYVV+YeYjQF2jCRWUo0
	OR8YF3kl8YbGZkYWpiamxkbmlmZK4ryvpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamD0
	ZFqQGnqquk/RlfuG610pxZRCI80N9gJGq8X1500LmNi38n7ELqunjJ4r+XPaDv4P9Z9ZarLI
	QCleJ5rB29vZO+WPhvtJfYu0rk0fUj7m34xrE/pza5FXUaHPezZFfwmvMm6pkKXCfjElPzhE
	993f+9dma9a7k9bZCdocy8Q8GX7P+763TomlOCPRUIu5qDgRAGiA+ldTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xgO7mh6whBu0HDS2aF69ns9j0+Bqr
	xeVdc9gsZpzfx2RxZnEvu8Wibf+ZLRZt/cLuwO6xc9Zddo/9c9ewe2xeUu/Rt2UVo8fnTXIB
	rFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDN2L77LXnCOo2L5uZlsDYxT
	2bsYOTkkBEwk7k/8yAphi0lcuLeeDcQWEljEKHH4r1gXIxeQ3c8kse7kUmaQBJuAmcTBRavB
	mkUEFCTetLxkBiliFnjKKHH52CqwbmEBd4k7D08CTeXgYBFQlXi4UQ4kzCvgIrF76Xx2kLAE
	UO+cSTYTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOiGdSOxhXNlgcYhTgYFTi
	4ZX8wRIixJpYVlyZe4hRgoNZSYR370XWECHelMTKqtSi/Pii0pzU4kOMpkC7JzJLiSbnA6M1
	ryTe0NjE3NTY1NLEwsTMUkmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QDoyDjys/zV83T59u5
	V+b3wnPJgpPEDj72N8o1OmwWv05w08UPya0d3LPjJl0qf+up2GDFM7fxnPWNs/8KDFdcbNgc
	d0DuR7KZZf2uzge9W3+2z/FKZi47/7MpT+amrovlv/hAZhlnkVlMide0PlmZbrv8PdDeXv22
	1OuDXgurpvxWqhDnd3kirsRSnJFoqMVcVJwIABJycXSeAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dubey <pankaj.dubey@samsung.com>

Make the config symbols SERIAL_SAMSUNG_UARTS_4 and
SERIAL_SAMSUNG_UARTS depend on SERIAL_SAMSUNG rather than
PLAT_SAMSUNG.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 26cec64..4f27f0c 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -230,14 +230,14 @@ config SERIAL_SAMSUNG
 
 config SERIAL_SAMSUNG_UARTS_4
 	bool
-	depends on PLAT_SAMSUNG
+	depends on SERIAL_SAMSUNG
 	default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
 	help
 	  Internal node for the common case of 4 Samsung compatible UARTs
 
 config SERIAL_SAMSUNG_UARTS
 	int
-	depends on PLAT_SAMSUNG
+	depends on SERIAL_SAMSUNG
 	default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
 	default 3
 	help
-- 
1.7.9.5

