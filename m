Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbaE3Qm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:42:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60048 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247AbaE3Qm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:42:28 -0400
Date: Fri, 30 May 2014 11:42:25 -0500 (CDT)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] qcom defconfig changes for v3.16-2
Message-ID: <alpine.DEB.2.00.1405301141060.5291@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f604759ec025e21d0c29a6d0addd53bbc60eb12e:

   ARM: config: Update msm_defconfig (2014-05-22 11:18:56 -0500)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-defconfig-for-3.16-2

for you to fetch changes up to 15ce39ade232bdac9fb788c66da9bcc7eb1a46a9:

   ARM: qcom: Enable GSBI driver in defconfig (2014-05-29 11:27:03 -0500)

----------------------------------------------------------------
Qualcomm ARM Based defconfig Updates for v3.16-2

* Enable qcom GSBI driver

----------------------------------------------------------------
Kumar Gala (1):
       ARM: qcom: Enable GSBI driver in defconfig

  arch/arm/configs/qcom_defconfig | 1 +
  1 file changed, 1 insertion(+)

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
