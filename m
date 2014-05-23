Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaEWSiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:38:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53770 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaEWSiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:38:07 -0400
Date: Fri, 23 May 2014 13:37:58 -0500 (CDT)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        gdjakov@mm-sol.com, iivanov@mm-sol.com
Subject: [GIT PULL] qcom DT changes for v3.15
Message-ID: <alpine.DEB.2.00.1405231337490.15680@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.16

for you to fetch changes up to 08f9234ad6b0b8bc51046346eabf5b92e631e62a:

   soc: qcom: Add device tree binding for GSBI (2014-05-23 11:38:53 -0500)

----------------------------------------------------------------
Qualcomm ARM Based Device Tree Updates for v3.16

* Added device tree nodes for pinctrl and SDHC for msm8974 SoC/DB8074 board
* Added binding spec for GSBI configuration node

----------------------------------------------------------------
Andy Gross (1):
       soc: qcom: Add device tree binding for GSBI

Georgi Djakov (1):
       ARM: dts: msm: Add SDHC controller nodes for MSM8974 and DB8074 board

Ivan T. Ivanov (1):
       ARM: dts: MSM8974: Add pinctrl node

  .../devicetree/bindings/soc/qcom/qcom,gsbi.txt     | 78 ++++++++++++++++++++++
  arch/arm/boot/dts/qcom-apq8074-dragonboard.dts     | 13 ++++
  arch/arm/boot/dts/qcom-msm8974.dtsi                | 51 ++++++++++++++
  include/dt-bindings/soc/qcom,gsbi.h                | 26 ++++++++
  4 files changed, 168 insertions(+)
  create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt
  create mode 100644 include/dt-bindings/soc/qcom,gsbi.h

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
