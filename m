Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaGNLR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:17:56 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33050 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaGNLRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:17:49 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-ide@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4 0/2] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
Date: Mon, 14 Jul 2014 12:17:31 +0100
Message-Id: <1405336651-32135-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

First patch in this series adds support to the APQ8064 SATA PHY.
Second patch updates the existing Kumar gala's device tree PHY bindings
with APQ8064 soc specific compatible.

Eventhough there are two seperate drivers for both IPQ and APQ SOCs,
the bindings are exactly same, so I did not create new bindings document.

Could you please pick these patches for v3.17.

Changes since v3:
	- Rebased to linux-phy next branch as requested by Kishon
	- Added dedicated apq8064 sata phy bindings as suggested by Kishon

Changes since v2:
	- added usleep_range in poll timeout as discussed
		with Bartlomiej Zolnierkiewicz.
	- Added missing pdev_set_drvdata spotted by 
		Bartlomiej Zolnierkiewicz

Changes since v1:
	- included DT bindings in the series.

Thanks,
srini

Srinivas Kandagatla (2):
  phy: qcom: Add driver for QCOM APQ8064 SATA PHY
  phy: qcom: Add APQ8064 SATA PHY device tree bindings

 .../bindings/phy/qcom-apq8064-sata-phy.txt         |  24 ++
 drivers/phy/Kconfig                                |   7 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-qcom-apq8064-sata.c                | 288 +++++++++++++++++++++
 4 files changed, 320 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-apq8064-sata-phy.txt
 create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c

-- 
1.9.1

