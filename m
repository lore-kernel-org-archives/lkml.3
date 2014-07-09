Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaGILDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:03:44 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49881 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaGILDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:03:41 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-ide@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 0/2] Add Qcom AP8064 SATA PHY support
Date: Wed,  9 Jul 2014 12:03:27 +0100
Message-Id: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403546409-10860-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1403546409-10860-1-git-send-email-srinivas.kandagatla@linaro.org>
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

Changes since v1:
	- included DT bindings in the series.

Thanks,
srini

Srinivas Kandagatla (2):
  phy: qcom: Add driver for QCOM APQ8064 SATA PHY
  phy: qcom: Update APQ8064 PHY device tree bindings

 Documentation/devicetree/bindings/phy/qcom-phy.txt |   3 +-
 drivers/phy/Kconfig                                |   7 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-qcom-apq8064-sata.c                | 358 +++++++++++++++++++++
 4 files changed, 368 insertions(+), 1 deletion(-)
 create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c

-- 
1.9.1

