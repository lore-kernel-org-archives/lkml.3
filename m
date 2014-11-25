Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaKYP72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:59:28 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39446 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaKYP70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:59:26 -0500
Date: Tue, 25 Nov 2014 15:59:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it,
        lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [GIT PULL] Immutable branch between MFD, Regulator and Clk, due for
 v3.19
Message-ID: <20141125155918.GO4241@x1>
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, Mike,

Please merge this into your trees for v3.19.

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-regulator-clk-v3.19

for you to fetch changes up to 159a5e920446aed12fe373ecc3c7b3dc667091ae:

  mfd: s2mps11: Add binding documentation for Samsung S2MPS13 PMIC (2014-11-25 15:55:12 +0000)

----------------------------------------------------------------
Immutable branch between MFD, Regulator and Clk, due for v3.19

----------------------------------------------------------------
Chanwoo Choi (4):
      mfd: sec-core: Add support for S2MPS13 device
      regulator: s2mps11: Add support S2MPS13 regulator device
      clk: s2mps11: Add the support for S2MPS13 PMIC clock
      mfd: s2mps11: Add binding documentation for Samsung S2MPS13 PMIC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |  22 +--
 drivers/clk/clk-s2mps11.c                         |  24 +++
 drivers/mfd/sec-core.c                            |  29 ++++
 drivers/mfd/sec-irq.c                             |  23 ++-
 drivers/regulator/Kconfig                         |  10 +-
 drivers/regulator/s2mps11.c                       | 102 +++++++++++-
 include/linux/mfd/samsung/core.h                  |   2 +
 include/linux/mfd/samsung/s2mps13.h               | 186 ++++++++++++++++++++++
 8 files changed, 374 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps13.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
