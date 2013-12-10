Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3LJK4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:56:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41612 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3LJK4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:56:02 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-3e-52a6f33fb003
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com, kishon@ti.com,
        jg1.han@samsung.com, jwerner@chromium.org
Subject: [PATCH RFC 0/4] Fine tune USB 3.0 PHY on exynos5420
Date: Tue, 10 Dec 2013 16:25:22 +0530
Message-id: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkTtf+87Igg9al5hYH79dbNC9ez2Zx
	eeElVouOQ4+ZLHoXXGWzuPC0Byi2aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB26P2Q0XWTzm
	nQz02D93DbtH35ZVjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjfLoEr42z3CsaCZVwVcy+tYWpg
	7OHoYuTkkBAwkfjU/poZwhaTuHBvPVsXIxeHkMBSRonZS3exdzFygBVd+OULEZ/OKHHqxFpW
	kAYhgSlMElMXl4DYbAK6Ek1vdzGC2CICDhJLlt4BG8QscItRomVqB1iDsICNxKzpbWA2i4Cq
	RNu2PrDNvAIeEvunH2SDuEJB4s3tZ8wgzRICq9glpi/awAbRICDxbfIhFoiLZCU2HYC6WlLi
	4IobLBMYBRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECAzy0/+e9e1gvHnA+hBjMtC4
	icxSosn5wCjJK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2M7XO5mfl9Y09uc3SS9X20oDRl1XkfPr4Wpo0Tc2fsPX/BX99W8/LMVhOP9SerTsQy
	Pf4Qs+BWe2a5jUhKyZllCwQWiJWc3MeyaL630hSzScev3eo6yJnuG3VumXf1/fT8e1b9fj8/
	qTR+6D6duOzRCfb1nkUBb2QztTLy5iTb9Dx5Gqf+Iv6bEktxRqKhFnNRcSIAvYN36ogCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQV37z8uCDDZu1bM4eL/eonnxejaL
	ywsvsVp0HHrMZNG74CqbxYWnPUCxXXPYLGYv6WexmHF+H5PFomWtzBbNJ04xO3B7zG64yOIx
	72Sgx/65a9g9+rasYvQ4fmM7k8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
	hrqGlhbmSgp5ibmptkouPgG6bpk5QOcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLr
	MTJAAwlrGDPOdq9gLFjGVTH30hqmBsYeji5GDg4JAROJC798uxg5gUwxiQv31rN1MXJxCAlM
	Z5Q4dWItK0hCSGAKk8TUxSUgNpuArkTT212MILaIgIPEkqV3wBqYBW4xSrRM7QBrEBawkZg1
	vQ3MZhFQlWjb1scMYvMKeEjsn36QDWKbgsSb28+YJzByL2BkWMUomlqQXFCclJ5rpFecmFtc
	mpeul5yfu4kRHEPPpHcwrmqwOMQowMGoxMMr8W9pkBBrYllxZe4hRgkOZiUR3m0vlgUJ8aYk
	VlalFuXHF5XmpBYfYkwG2j6RWUo0OR8Y33kl8YbGJuamxqaWJhYmZpakCSuJ8x5stQ4UEkhP
	LEnNTk0tSC2C2cLEwSnVwDhzjSfj026bZaWM+dea2M88u+FlwV66MWWmd/ACf+YvSlOdJ564
	H77/48Q5q68uWfF19bOoKbkKl4S9Zka6vQlzkHOrutDCKCVk/0NZ47GthJ4QxzxGh0fTP9zJ
	8V7mx7fw6pr3bWcef97X7tO05BWrgVBug03m7d+HnNM/bXb6/81n2vOGMDMlluKMREMt5qLi
	RADab0hE5QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DWC3-exynos eXtensible host controller present on Exynos5420
SoC is quirky. The PHY serving this controller operates at High-Speed
by default, so it detects even Super-speed devices as high-speed ones.
This PHY needs to be tuned for its Tx LOS levels and Boost levels.

In this patch-set, we are registering a quirk for this DWC3-Exynos
controller with XHCI, so that once after xhci_reset(), the controller
can call to tune the associated PHY and achieve the SuperSpeed.

These patches are based on new USB 3.0 phy driver for Exynos SoC series. [1]

[1] Add Exynos5 USB 3.0 phy driver based on generic PHY framework
http://lwn.net/Articles/575586/

Vivek Gautam (4):
  phy: Add provision for tuning phy.
  xhci: Add quirk for DWC3-Exynos controller
  xhci: Tune PHY for the DWC3-Exynos host controller
  phy-exynos-usb3: Fine tune LOS levels for exynos5420

 drivers/phy/phy-core.c         |   20 +++++++
 drivers/phy/phy-exynos5-usb3.c |  107 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/dwc3/host.c        |    7 +++
 drivers/usb/host/xhci-plat.c   |   62 ++++++++++++++++++++++-
 drivers/usb/host/xhci.h        |    1 +
 include/linux/phy/phy.h        |    7 +++
 include/linux/usb/hcd.h        |    1 +
 7 files changed, 203 insertions(+), 2 deletions(-)

-- 
1.7.6.5

