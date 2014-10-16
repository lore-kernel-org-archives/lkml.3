Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaJPIEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:04:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46263 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJPIEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:04:00 -0400
From: Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [GIT PULL] qcom DT changes for v3.18-3
Date: Thu, 16 Oct 2014 10:03:48 +0200
Message-Id: <FBA74704-E00F-4CD5-A07C-56B72F6755DA@codeaurora.org>
Cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Rapoport <mike.rapoport@gmail.com>,
        Tim Bird <tim.bird@sonymobile.com>
To: arm@kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit aabff7bfe55afd01d71a5f11d4a84bd873c20f5e:

  ARM: DT: msm8960: Add sdcc nodes (2014-09-22 13:49:43 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.18-3

for you to fetch changes up to 7dac24bdc1dd561573cd8ce534a63dc975f51ca8:

  ARM: dts: qcom: add CM-QS600 board (2014-10-16 02:48:36 -0500)

----------------------------------------------------------------
Qualcomm ARM Based Device Tree Updates for v3.18-3

* Added Board support for CM-QS600 and Sony Xperia Z1 phone
* Added SATA support on IPQ8064/AP148

----------------------------------------------------------------
Kumar Gala (1):
      ARM: dts: qcom: Add SATA support on IPQ8064/AP148

Mike Rapoport (1):
      ARM: dts: qcom: add CM-QS600 board

Tim Bird (1):
      ARM: dts: qcom: Add initial DTS file for Sony Xperia Z1 phone

 Documentation/devicetree/bindings/vendor-prefixes.txt |  1 +
 arch/arm/boot/dts/Makefile                            |  4 ++-
 arch/arm/boot/dts/qcom-apq8064-cm-qs600.dts           | 59 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/qcom-ipq8064-ap148.dts              |  8 ++++++
 arch/arm/boot/dts/qcom-ipq8064.dtsi                   | 33 ++++++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts | 17 ++++++++++++
 6 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/qcom-apq8064-cm-qs600.dts
 create mode 100644 arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

