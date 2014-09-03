Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaICDJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:09:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20171 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaICDJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:09:07 -0400
X-AuditID: cbfee691-f79546d0000011a1-a6-5406865181df
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, ch.naveen@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv6 0/2] thermal: exynos: Add support for TRIMINFO feature of
 Exynos3250
Date: Wed, 03 Sep 2014 12:09:01 +0900
Message-id: <1409713743-6124-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkWDewjS3E4OITFouGqyEWG2esZ7W4
	+/wwo8X1L89ZLdbs/8lk0bvgKpvF2aY37BabHl9jtbi8aw6bxefeI4wWM87vY7J48rCPzYHH
	Y/Gel0wem5fUe/RtWcXocfzGdiaPz5vkAlijuGxSUnMyy1KL9O0SuDJOte5lLdjDW3GkTa6B
	sZ27i5GTQ0LARKJ383YWCFtM4sK99WwgtpDAUkaJthUSMDUPp3QC1XABxaczSryb1MwM4TQx
	SayYeYAdpIpNQEti/4sbYN0iAp4Scxe2MIEUMQtMYpL4/OgzWEJYIELixJTXYOtYBFQlJu6+
	xQpi8wq4SNxbcZQNYp2cxIc9j9hBmiUEFrFLzL65jwmiQUDi2+RDQM0cQAlZiU0HmCHqJSUO
	rrjBMoFRcAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwCA//e/ZxB2M9w9YH2IU4GBU
	4uFdEMAWIsSaWFZcmXuI0RRow0RmKdHkfGAs5ZXEGxqbGVmYmpgaG5lbmimJ8+pI/wwWEkhP
	LEnNTk0tSC2KLyrNSS0+xMjEwSnVwCjrkP1KJi3beenc6S0rRWSbJn3Q3Wlb8OiAjo7TXNYz
	M7vdq0RZFG5Pd0tb2uO6u7gmuujqTBFDQ98Pz/LC9RZGLfaLfPLDxkH87IcOoXK9Xzvt5v+a
	P6tXefUN+WTpWY1qWg3zrP/Ff6zYb+9VcF9i1ZfFm7emr8uze3n3QnJh6dXb3V9Y9iixFGck
	GmoxFxUnAgDLAZltbQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQd2ANrYQg51PrSwaroZYbJyxntXi
	7vPDjBbXvzxntViz/yeTRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8niycM+Ngce
	j8V7XjJ5bF5S79G3ZRWjx/Eb25k8Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1
	MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6T0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQ
	XI+RARpIWMOYcap1L2vBHt6KI21yDYzt3F2MnBwSAiYSD6d0skDYYhIX7q1n62Lk4hASmM4o
	8W5SMzOE08QksWLmAXaQKjYBLYn9L26wgdgiAp4Scxe2MIEUMQtMYpL4/OgzWEJYIELixJTX
	YGNZBFQlJu6+xQpi8wq4SNxbcZQNYp2cxIc9j9gnMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iREcRc+kdjCubLA4xCjAwajEw7sggC1EiDWxrLgy9xCjBAezkgivbyJQiDclsbIq
	tSg/vqg0J7X4EKMp0PaJzFKiyfnACM8riTc0NjEzsjQyN7QwMjZXEuc90GodKCSQnliSmp2a
	WpBaBNPHxMEp1cDI0Cd5t53nheNSOxcx6dJ5jVtPxaWo2N0X6rye29O9UCKlfu8Ji+JD1of5
	HGKXZ6tIXRBdwWIQnGC8tHnFco47UXWTZzWdLcvclL4o5/3BP0+CV4v46kq/qw9fs/qd12t2
	duOy9IVn/jyLfZZzsmGbiLhyiO/6K/vv7OthXLqJOd3dVz+xiEWJpTgj0VCLuag4EQC6759/
	uAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add the support of TRIMINFO_RELOAD feature for Exynos3250.
But Exynos3250 has two TRIMINFO_CTRL register instead other Exynos has only one
TRIMINFO_CTRL register. So, this patchset support the some Exynos SoC which
has more than one TRIMINF_CTRL.

Also, this patchset fix wrong value of TRIMINFO_RELOAD_SHIFT and remove
duplicate code when reading triminfo register of Exynos5440.

Changes from v5:
- Rebase this patchset on next branch of linux-soc-thermal.git

Changes from v4:
- Remove un-necessary triminfo_ctrl_{shift, mask} field
- Includes Bartlomiej's patch[1] that Exynos5260 / Exynos5420 should not use
TRIM_RELOAD flag
[2] https://lkml.org/lkml/2014/8/20/481

Changes from v3:
- Add reviewed message of Amit Daniel Kachhap <amit.daniel@samsung.com>
- Split RELOAD patch as two patch
- Fix 'TRIMINFO_RELOAD_SHIFT' value
- This series includes separate patch[1]
[1] https://lkml.org/lkml/2014/8/20/5
- Drop ACTIME bit setting because TRM includes not enough information of ACTIME bit.

Changes from v2:
- Fix build break because of missing 'or' operation.

Changes from v1:
- Add missing 'TMU_SUPPORT_TRIM_RELOAD' features

Chanwoo Choi (2):
  thermal: exynos: Add support for many TRIMINFO_CTRL registers
  thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250

 drivers/thermal/samsung/exynos_thermal_common.h |  1 +
 drivers/thermal/samsung/exynos_tmu.c            | 15 ++++++++++++---
 drivers/thermal/samsung/exynos_tmu.h            |  7 +++++--
 drivers/thermal/samsung/exynos_tmu_data.c       | 11 +++++++++--
 drivers/thermal/samsung/exynos_tmu_data.h       |  8 ++++++--
 5 files changed, 33 insertions(+), 9 deletions(-)

-- 
1.8.0

