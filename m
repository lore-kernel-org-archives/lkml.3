Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaLSJ3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:29:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64318 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLSJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:29:38 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-bb-5493efffd019
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/2] regulator: Simplify max77693 driver
Date: Fri, 19 Dec 2014 10:29:17 +0100
Message-id: <1418981359-16457-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xq7r/308OMVg2Uc9i6sMnbBavXxha
	3P96lNHi25UOJovLu+awWZzuZnVg89g56y67x6ZVnWwed67tYfOYdzLQo2/LKkaPz5vkAtii
	uGxSUnMyy1KL9O0SuDI6G1czFnxmrVjf2MLUwPiUpYuRk0NCwESi5fABJghbTOLCvfVsXYxc
	HEICSxkl7s+9xA7h9DFJ3F79hRGkik3AWGLz8iVgVSICmxglOh4vBkswCxhK/Hz3hx3EFhaw
	kHi4uIUZxGYRUJX4s+IiWJxXwF1i9bt5bBDr5CROHpvMOoGRewEjwypG0dTS5ILipPRcQ73i
	xNzi0rx0veT83E2MkBD5soNx8TGrQ4wCHIxKPLwvqyaHCLEmlhVX5h5ilOBgVhLhdTwOFOJN
	SaysSi3Kjy8qzUktPsTIxMEp1cCouP1DyqLJH8J37jwsrdG6q79rnUP/1sf3maK72qQnhd/R
	/yp45+aEfb+Eu2MOhBbrrTn38+Su/JSa1G4rnnVKS3WbRafwc7x3MgrQleLOm58+MUCGbbKF
	V41e1OtzUwI79KSt3otUnHON1qlfd1uzZYvTXDnHMt7Omd9SNBRPvr94wWRGp5USS3FGoqEW
	c1FxIgD96o5A7wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Simplify the max77693 regulator driver by moving DT parse code out
to regulator core.

This removes also board file support. Exynos based boards are DT-only.
This removal allows bigger simplification of driver so overall diffstat
is nice: -95 deletions, 12 additions.

The patch 2/2 depends on first patch so please apply everything at once
or leave second patch for later.

Best regards,
Krzysztof

Krzysztof Kozlowski (2):
  regulator: max77693: Let core parse DT and drop board files support
  mfd: max77693: Remove unused structures

 drivers/regulator/max77693.c | 93 +++++---------------------------------------
 include/linux/mfd/max77693.h | 12 +-----
 2 files changed, 10 insertions(+), 95 deletions(-)

-- 
1.9.1

