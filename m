Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaDXPHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:07:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11812 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbaDXPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:07:14 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-d3-535928a02e9e
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, broonie@kernel.org,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH] i2c: mux: Use subsys_initcall for the i2c-arb-gpio-challenge
Date: Thu, 24 Apr 2014 20:35:22 +0530
Message-id: <1398351922-1647-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkSnehRmSwwYrtbBZTHz5hs3h5SNPi
	7LKDbBavjvxgstj0+BqrRcffL4wWl3fNYbOYcX4fk8Wibf+ZLb5t2cZosfLELGYHbo/ZDRdZ
	PHbOusvusWlVJ5vH5iX1Hn1bVjF6nDz1hMXj8ya5APYoLpuU1JzMstQifbsEroyN5xULLvFV
	TH59lrGBcTtPFyMnh4SAiUTz+V5GCFtM4sK99WxdjFwcQgJLGSU2/NrIDlN06dRkJhBbSGAR
	o8T323IQRf1MErfvrmQDSbAJmEkcXLQarEFEQFai9cEa5i5GDg5mgSlMEotjQMLCAr4Sre+v
	sILYLAKqEntmPQCzeQVcJPZs7mEBKZcQUJCYM8kGZLyEwCp2ie3n2xkh6gUkvk0+BFUjK7Hp
	ADPEaZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmCgn/73rH8H490D
	1ocYk4HGTWSWEk3OB0ZKXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUX
	leakFh9iZOLglGpgTDf4HHW/eKm65ZUFkxn3WoiZzZ5XUpJ+s61Nlmst49RTB7srr+15xda2
	27KV9arHUZUmY9Wr2f4XVV/cOHAwkrO4OLsm47JQ0a8iPYbs1pKyypAb0Zfzfs4QkW/p2Pdi
	Qk//oVrzq0sUHlU9LmP6Prun7NkeLuZHxfd0Dbd+ZZz68uzH80JtSizFGYmGWsxFxYkA1Krn
	HooCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd0FGpHBBvs7LCymPnzCZvHykKbF
	2WUH2SxeHfnBZLHp8TVWi46/XxgtLu+aw2Yx4/w+JotF2/4zW3zbso3RYuWJWcwO3B6zGy6y
	eOycdZfdY9OqTjaPzUvqPfq2rGL0OHnqCYvH501yAexRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA3KimUJeaUAoUCEouLlfTtME0IDXHTtYBp
	jND1DQmC6zEyQAMJaxgzNp5XLLjEVzH59VnGBsbtPF2MnBwSAiYSl05NZoKwxSQu3FvPBmIL
	CSxilPh+W66LkQvI7meSuH13JViCTcBM4uCi1ewgtoiArETrgzXMXYwcHMwCU5gkFseAhIUF
	fCVa319hBbFZBFQl9sx6AGbzCrhI7NncwwJSLiGgIDFnks0ERu4FjAyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYLj6Jn0DsZVDRaHGAU4GJV4eCfIRgYLsSaWFVfmHmKU4GBWEuFVVAcK
	8aYkVlalFuXHF5XmpBYfYkwGWj6RWUo0OR8Y43kl8YbGJuamxqaWJhYmZpakCSuJ8x5stQ4U
	EkhPLEnNTk0tSC2C2cLEwSnVwDjDsfj6r5sXOZ12vDpQteLc3/Mihz8uknqwvUdYS+Nq97Is
	FvVTN07oH+3wEXi0aq7WE++O5esN3q3jO6Rrcp0lKz2o8vTfOsOYKIvGj2mm0x2XcNctZMq0
	jFbRL7ihlyn4LNar46mJicUslSw7H5+6fX7VUfbH9Dfx/PrbOtE327bAc57QdCWW4oxEQy3m
	ouJEAFtb/snnAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

Since many drivers rely on FETs that live behind this arbitrator, they
can't successfully probe until after the arbitrator comes up.  They
ought to handle things properly with EPROBE_DEFER and still work, but
that has some downsides:

1. Those drivers don't come up till later in the boot process.  That
   really not so nice for the LCD--we want that to init early.
2. Some drivers have bugs and don't handle EPROBE_DEFER.  Those
   drivers should be fixed but not all of them have been fixed yet.
   HDMI is one example since DRM doesn't really have good support for
   deferring probes.

With this change We end up using the same init level as the main i2c bus.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-on: https://gerrit.chromium.org/gerrit/57007
Reviewed-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
index 69afffa..6cf52bb 100644
--- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -241,7 +241,17 @@ static struct platform_driver i2c_arbitrator_driver = {
 	},
 };
 
-module_platform_driver(i2c_arbitrator_driver);
+static int __init i2c_arbitrator_init(void)
+{
+	return platform_driver_register(&i2c_arbitrator_driver);
+}
+subsys_initcall(i2c_arbitrator_init);
+
+static void __exit i2c_arbitrator_exit(void)
+{
+	platform_driver_unregister(&i2c_arbitrator_driver);
+}
+module_exit(i2c_arbitrator_exit);
 
 MODULE_DESCRIPTION("GPIO-based I2C Arbitration");
 MODULE_AUTHOR("Doug Anderson <dianders@chromium.org>");
-- 
1.7.9.5

