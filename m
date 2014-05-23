Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaEWSjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:39:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53953 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaEWSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:39:33 -0400
Date: Fri, 23 May 2014 13:39:30 -0500 (CDT)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, sboyd@codeaurora.org
Subject: [GIT PULL] qcom defconfig changes for v3.16
Message-ID: <alpine.DEB.2.00.1405231338080.15680@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-defconfig-for-3.16

for you to fetch changes up to f604759ec025e21d0c29a6d0addd53bbc60eb12e:

   ARM: config: Update msm_defconfig (2014-05-22 11:18:56 -0500)

----------------------------------------------------------------
Qualcomm ARM Based defconfig Updates for v3.16

* Add a new qcom_defconfig for mach-qcom
* Update msm_defconfig for handling building the old mach-msm

----------------------------------------------------------------
Stephen Boyd (2):
       ARM: config: Add qcom_defconfig
       ARM: config: Update msm_defconfig

  arch/arm/configs/msm_defconfig  |  25 +-----
  arch/arm/configs/qcom_defconfig | 164 ++++++++++++++++++++++++++++++++++++++++
  2 files changed, 167 insertions(+), 22 deletions(-)
  create mode 100644 arch/arm/configs/qcom_defconfig

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
