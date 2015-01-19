Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbbASS0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:26:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41170 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbASS0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:26:01 -0500
Date: Mon, 19 Jan 2015 12:25:51 -0600 (CST)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, pramod.gurav@smartplayin.com
Subject: [GIT PULL] qcom DT changes for v3.20
Message-ID: <alpine.DEB.2.02.1501191224310.2973@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.20

for you to fetch changes up to bb901bd6596e93fc2e0fc6da2f367a651bd8d16e:

   ARM: dts: qcom: Correct IPQ8064 tlmm interrupt (2015-01-19 12:11:41 -0600)

----------------------------------------------------------------
Qualcomm ARM Based Device Tree Updates for v3.20

* Correct IPQ8064 tlmm interrupt
* Add Support for SD Card Detect for ifc6410 board

----------------------------------------------------------------
Pramod Gurav (1):
       ARM: dts: qcom: Add Support for SD Card Detect for ifc6410 board

Stephen Boyd (1):
       ARM: dts: qcom: Correct IPQ8064 tlmm interrupt

  arch/arm/boot/dts/qcom-apq8064-ifc6410.dts | 12 ++++++++++++
  arch/arm/boot/dts/qcom-ipq8064.dtsi        |  2 +-
  2 files changed, 13 insertions(+), 1 deletion(-)

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
