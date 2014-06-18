Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965743AbaFRJy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:54:57 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:47703 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965640AbaFRJyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:54:55 -0400
Date: Wed, 18 Jun 2014 10:54:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, sbkim73@samsung.com,
        k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, t.figa@samsung.com,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [GIT PULL] Mark - Immutable branch between MFD and Regulator
Message-ID: <20140618095448.GK23945@lee--X1>
References: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-regulator-v3.17

for you to fetch changes up to d1f79ff65b2c6a9e2785ac94c2eb6a5229859251:

  dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC (2014-06-18 10:18:45 +0100)

----------------------------------------------------------------
Immutable branch between MFD and Regulator for v3.17

----------------------------------------------------------------
Chanwoo Choi (3):
      mfd: sec-core: Add support for S2MPU02 device
      regulator: s2mps11: Add support S2MPU02 regulator device
      dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   7 +-
 drivers/mfd/sec-core.c                            |  71 ++++-
 drivers/mfd/sec-irq.c                             | 110 ++++++--
 drivers/regulator/s2mps11.c                       | 321 ++++++++++++++++++++--
 include/linux/mfd/samsung/core.h                  |   1 +
 include/linux/mfd/samsung/irq.h                   |  24 ++
 include/linux/mfd/samsung/s2mpu02.h               | 201 ++++++++++++++
 7 files changed, 682 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
