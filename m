Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbbAVEGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:06:54 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19965 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbAVEGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:06:45 -0500
X-AuditID: cbfee68e-f79b46d000002b74-24-54c077521f98
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, robh+dt@kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, dbaryshkov@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH v4 0/2] power: rt5033: Add Richtek RT533 drivers
Date: Thu, 22 Jan 2015 13:06:38 +0900
Message-id: <1421899601-19327-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkSDeo/ECIQcdDfYvTn7axW0x9+ITN
	4vqX56wWk568Z7aYf+Qcq0X/m4WsFuderWS0mHR/AovF+z1nGC0u75rDZvG59wijxdLrF5ks
	Jkxfy2LRuvcIu8Xp3SUWMya/ZHMQ8Fgzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	9G1ZxejxeZNcAEcUl01Kak5mWWqRvl0CV0bfvLPsBQs5K5bP/sfSwNjO3sXIySEhYCKx5tEt
	NghbTOLCvfVANheHkMBSRolTPzYwwxRd293LCpFYxCgx6/pPJpCEkEAbk8SGPZUgNpuApsT7
	KVdYQGwRgRqJSWfeg01iFpjAJPH382awdcICDhIf//0Cm8oioCpxe81GMJtXwE3i68r5QDUc
	QNsUJOZMsoFYfI1d4tdTWYhyAYlvkw+xQJTISmw6AHWbpMTBFTdYJjAKLmBkWMUomlqQXFCc
	lF5kpFecmFtcmpeul5yfu4kRGCun/z3r28F484D1IUYBDkYlHt6M4gMhQqyJZcWVuYcYTYE2
	TGSWEk3OB0ZkXkm8obGZkYWpiamxkbmlmZI4b4LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjHGLeB56ei2Reu/OPP9l/AxR192yN68vYjGf+NKgcakCy/qcw1+f7rz+yLLmdYLLxC/V
	4Xs4lA0DT9ZYlZ7puq0cVKOzf/vRNGPNYNX/vzdyVNhHH/RK78jZHCrU6tzlGN4enW2tv+tA
	5Z71kjwV+9Q7OYpvqtVmTDkjfqKmSuS6xK8tZXwTlFiKMxINtZiLihMB7q+fvZACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jAd2g8gMhBic71CxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBb9bxayWpx7tZLRYtL9CSwW7/ecYbS4vGsOm8Xn3iOMFkuvX2Sy
	mDB9LYtF694j7Band5dYzJj8ks1BwGPNvDWMHpf7epk8ds66y+6xcvkXNo9NqzrZPO5c28Pm
	0bdlFaPH501yARxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZK
	Lj4Bum6ZOUAvKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz+uadZS9Y
	yFmxfPY/lgbGdvYuRk4OCQETiWu7e1khbDGJC/fWs3UxcnEICSxilJh1/ScTSEJIoI1JYsOe
	ShCbTUBT4v2UKywgtohAjcSkM+/BGpgFJjBJ/P28GWyqsICDxMd/v5hBbBYBVYnbazaC2bwC
	bhJfV84HquEA2qYgMWeSzQRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPxmfQO
	xlUNFocYBTgYlXh4M4oPhAixJpYVV+YeYpTgYFYS4fXQAArxpiRWVqUW5ccXleakFh9iNAVa
	PpFZSjQ5H5gm8kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGO1e
	aqY8z+s2C2NbfvrrMfWZEZ9Cgq4YFrva9uyUty+beSyg7BH/AV1ThRWXN7Vl+i8xW3iqw15P
	Ja/IrOlAQ+HZDYJCTx4UGL30KNTnU9m47X7xscQb2XH2S1eI5M+a7HOr7+Fz10ttLb47wtm7
	Xr67yXvmaNT9h5If+kXyv6hs6l3cXaqSp8RSnJFoqMVcVJwIAI3SjU3bAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds driver for Richtek rt5033 chip The chip contains
switching charge mode Li-Ion/Li-Polymer battery charger, fuelgauge.
Additionally, This includes document for device tree of RT5033 device.

RT5033 core driver is applied by Lee Jones.
RT5033 regulator driver is applied by Mark Brown.
RT5033 fuelgauge driver is applied by Sebastian Reichel.

Changes in v4:
- Change power supply type.

Changes in v3:
- Applied one of patchset.
- Add acked-by.

Changes in v2:
- Revise binding documentation..

Beomho Seo (2):
  power: rt5033_charger: Add RT5033 charger device driver
  Documentation: Add documentation for rt5033 multifunction device

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/power/Kconfig                              |    8 +
 drivers/power/Makefile                             |    1 +
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 5 files changed, 596 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/power/rt5033_charger.c

-- 
1.7.9.5

