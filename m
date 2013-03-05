Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab3CEErM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:47:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56437 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3CEErJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:47:09 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-da-513578ccde9d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] mfd: ab3100-otp: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 13:47:06 +0900
Message-id: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ZXH0Yw9kuA009QHe2/LULknNrfg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t8zA90zFaaBBqeuS1hcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujOmT1rIUzOGouHqolbGBsZW9
	i5GTQ0LAROLA17lsELaYxIV764FsLg4hgWWMEsf/vWeFKfpz/CozRGI6o0Rr50Ooql+MEo/e
	P2AGqWITUJP48uUw2FgRAS2J7mPngYo4OJgFXCSOThMBMYUFPCSWP7EBqWARUJVY19oENp9X
	wFZi6clLLBC2oMSPyffAbGagKZu3QdQwC8hLbF7zlhlkjISAusSjv7oQi/QkFnz+DFUuIrHv
	xTtGkMskBOaxS+y70cACsUtA4tvkQywQvbISmw4wQ7wlKXFwxQ2WCYxis5BsnoVk8ywkm2ch
	WbGAkWUVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRkgs9e1gvHnA+hBjMtD6icxSosn5wFjM
	K4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG41V7
	XknXlm15aDOlvVyiweTUyQpxdavsxxOmPLlosKVpbfd+N/P1rXctLZ9cVDZg53V+u8r64Y0f
	SzbpMG6unzN7wyKVOu6+36ElBzKvv+45x/Fl8fmFVxU4EkRM/r9Ld5vsFNB/eAWnUev5zTZ3
	UhKlJkVH17HXVu9genKR/2HFhulyX96dVWIpzkg01GIuKk4EAAthWkO7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoO6ZCtNAg90HRSwuL7zEanF51xw2
	i9PdrA7MHvNOBnr0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGEdY8b0SWtZCuZwVFw91MrYwNjK3sXIySEhYCLx5/hVZghbTOLCvfVsXYxcHEIC0xklWjsf
	Qjm/GCUevX8AVsUmoCbx5cthsG4RAS2J7mPngYo4OJgFXCSOThMBMYUFPCSWP7EBqWARUJVY
	19rECmLzCthKLD15iQXCFpT4MfkemM0MNGXzNogaZgF5ic1r3jKDjJEQUJd49FcXYpGexILP
	n6HKRST2vXjHOIFRYBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+du
	YgRH6jOpHYwrGywOMQpwMCrx8DIcNQkUYk0sK67MPcQowcGsJMJ7n9c0UIg3JbGyKrUoP76o
	NCe1+BBjMtCjE5mlRJPzgUkkryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNLUrNTUwtS
	i2C2MHFwSjUw9vZLGAqGtuf5Lj5wbqLCA9XW31PTlod/kf88LehXwrPDQikdSkstzP6xZ9f3
	+3/ZuOx/xJVHqxqmJh+4ybZUNsH/QP7BIJ+TQfNmvV6ZuXZh9gSeZT9CTknPKP266v+uia4V
	R2/oidr7+L3jk5LL9PrTvUDo6LYOA1kbJhmBPkfRueVvl+5MUmIpzkg01GIuKk4EAIJdNVkY	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ab3100-otp.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
index 8440010..d7ce016 100644
--- a/drivers/mfd/ab3100-otp.c
+++ b/drivers/mfd/ab3100-otp.c
@@ -248,19 +248,7 @@ static struct platform_driver ab3100_otp_driver = {
 	.remove	 = __exit_p(ab3100_otp_remove),
 };
 
-static int __init ab3100_otp_init(void)
-{
-	return platform_driver_probe(&ab3100_otp_driver,
-				     ab3100_otp_probe);
-}
-
-static void __exit ab3100_otp_exit(void)
-{
-	platform_driver_unregister(&ab3100_otp_driver);
-}
-
-module_init(ab3100_otp_init);
-module_exit(ab3100_otp_exit);
+module_platform_driver_probe(ab3100_otp_driver, ab3100_otp_probe);
 
 MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
 MODULE_DESCRIPTION("AB3100 OTP Readout Driver");
-- 
1.7.2.5


