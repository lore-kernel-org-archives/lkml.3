Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaHZMqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:46:46 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33020 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbaHZMqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:46:44 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linus.walleij@linaro.org, galak@codeaurora.org,
        bjorn.andersson@sonymobile.com, agross@codeaurora.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, grant.likely@linaro.org,
        sboyd@codeaurora.org, iivanov@mm-sol.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v2 0/3] pinctrl: qcom: Add APQ8084 pinctrl support
Date: Tue, 26 Aug 2014 15:45:53 +0300
Message-Id: <1409057156-1201-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds pinctrl support for the Qualcomm APQ8084 platform.
The first patch adds the pin definitions. The second patch contains the
devicetree binding documentation. The last patch adds the DT node.

Tested on IFC6540 board.

Changes since v1:
 - Updated the total number of pins (suggested by Bjorn Andersson)
 - Added the missing pin info (provided by Andy Gross)
 - Updated groups and functions to be consistent with other pinctrls.
   (suggested by Andy Gross)
 - Removed unused functions, qdss and test pins. (suggested by Andy Gross)
 - Updated the documentation with the possible functions.

Georgi Djakov (3):
  pinctrl: qcom: Add APQ8084 pinctrl support
  dt: Document Qualcomm APQ8084 pinctrl binding
  ARM: dts: qcom: Add TLMM DT node for APQ8084

 .../bindings/pinctrl/qcom,apq8084-pinctrl.txt      |  104 ++
 arch/arm/boot/dts/qcom-apq8084.dtsi                |   10 +
 drivers/pinctrl/qcom/Kconfig                       |    8 +
 drivers/pinctrl/qcom/Makefile                      |    1 +
 drivers/pinctrl/qcom/pinctrl-apq8084.c             | 1243 ++++++++++++++++++++
 5 files changed, 1366 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
 create mode 100644 drivers/pinctrl/qcom/pinctrl-apq8084.c

-- 
1.7.9.5

