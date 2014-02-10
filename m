Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBJBPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:15:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64860 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBJBPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:15:14 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-c8-52f82820246e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
In-reply-to: <003901cf25fc$73002790$590076b0$%han@samsung.com>
Subject: [PATCH 5/7] Input: max8997_haptic: remove HAVE_PWM dependencies
Date: Mon, 10 Feb 2014 10:15:12 +0900
Message-id: <003e01cf25fd$8c310490$a4930db0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l/GYGhOsBgXmsQoSPhLhnprg0iAAAMvBA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ10FjR9BBkdXGVkcXvSC0eLmp2+s
	Fpd3zWFzYPbYOesuu8fnTXIBTFFcNimpOZllqUX6dglcGftP3WIumM1e0dHZz9bA+JO1i5GT
	Q0LAROLolZ9sELaYxIV764FsLg4hgWWMEo9mTGCHKTq8qoEFIrGIUeLW0TVMEM4vRon3/Q/A
	qtgE1CS+fDkMZHNwiAgYSsxYUwUSZhawlVgwoQWsRAjIntuwH8zmFLCTmLf0G9gVwgIeEqeO
	LwS7gkVAVWLpzsdgNi9QfUP7chYIW1Dix+R7LBAztSTW7zzOBGHLS2xe85YZZK2EgLrEo7+6
	IGERASOJf30fWCFKRCT2vXjHCHKyhMA2domXi6ayQuwSkPg2+RALRK+sxKYDzBD/SkocXHGD
	ZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRESdxN3MN4/
	YH2IMRlo/URmKdHkfGDc5pXEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2xJDU7NbUgtSi+
	qDQntfgQIxMHp1QD47kX00sniPWf731z99ymIMFzb44Ln2JgOjMjUS160rotpRJLW6fEKfOK
	L+yXzbqrIC5ycFaz2e3kzueTrY4YV6UZ/mnhCAve/f7WRybnyq3vo+vc1ev+r+hweaX6Y0rH
	6td/e3+0Vgi11zSp21zY+O7OeQNPPct5BcmWdzi+R4XVngy60/acSYmlOCPRUIu5qDgRAARK
	w/vRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAV0FjR9BBk0z9C0OL3rBaHHz0zdW
	i8u75rA5MHvsnHWX3ePzJrkApqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoCVKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6
	xoz9p24xF8xmr+jo7GdrYPzJ2sXIySEhYCJxeFUDC4QtJnHh3nq2LkYuDiGBRYwSt46uYYJw
	fjFKvO9/wA5SxSagJvHly2Egm4NDRMBQYsaaKpAws4CtxIIJLWAlQkD23Ib9YDangJ3EvKXf
	wJYJC3hInDq+kA3EZhFQlVi68zGYzQtU39C+nAXCFpT4MfkeC8RMLYn1O48zQdjyEpvXvGUG
	WSshoC7x6K8uSFhEwEjiX98HVogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMFR/Ux6B+OqBotDjAIcjEo8vDv+fA8SYk0sK67MPcQowcGs
	JML78i5QiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBCSevJN7Q2MTMyNLIzMLIxNycNGEl
	cd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgbt91aL7YlzkVQ/+n6IPcrBr9UX7Xu1hZP2mEg
	/3rmgWjD7G99D5Ss5uhe5mNkKlvvJX73UQz/Fd5JvKGa/+8VTPnlrsDxd5Fe/dNnZm9WHFWe
	L7nJpE+99f78ppV/a1KMVmQdD/56JtFY+NzC2Ie1chpXp5m5xrz2vfVO7M0Do5UrL3FXX49X
	YinOSDTUYi4qTgQAQT4KvS4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HAVE_PWM symbol is only for legacy platforms that provide
the PWM API without using the generic framework. However, legacy
PWM drivers were already moved to the generic PWM framework.
Thus, HAVE_PWM should be removed, because HAVE_PWM is not
required anymore.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/input/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7904ab0..ae74df7 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -156,7 +156,7 @@ config INPUT_MAX8925_ONKEY
 
 config INPUT_MAX8997_HAPTIC
 	tristate "MAXIM MAX8997 haptic controller support"
-	depends on PWM && HAVE_PWM && MFD_MAX8997
+	depends on PWM && MFD_MAX8997
 	select INPUT_FF_MEMLESS
 	help
 	  This option enables device driver support for the haptic controller
-- 
1.7.10.4


