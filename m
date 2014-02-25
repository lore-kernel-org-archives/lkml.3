Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaBYP3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:29:10 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50805 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaBYP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:29:08 -0500
Date: Tue, 25 Feb 2014 09:29:02 -0600 (CST)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Rohit Vaswani <rvaswani@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, David Brown <davidb@codeaurora.org>,
        linus.walleij@linaro.org, gnurou@gmail.com,
        herbert@gondor.apana.org.au, robdclark@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] qcom driver changes for v3.15
Message-ID: <alpine.DEB.2.00.1402250926210.17163@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cf1e8f0cd665e2a9966d2bee4e11ecc0938ff166:

   ARM: qcom: Rename various msm prefixed functions to qcom (2014-02-06 16:20:41 -0600)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-drivers-for-3.15

for you to fetch changes up to add798a40aec3a768165055477ba8bfee21e06fc:

   gpio: msm: switch Kconfig to ARCH_QCOM depends (2014-02-25 09:22:10 -0600)

----------------------------------------------------------------
Kumar Gala (5):
       tty: serial: msm: Enable building msm_serial for ARCH_QCOM
       drm/msm: drop ARCH_MSM Kconfig depend
       power: reset: msm - switch Kconfig to ARCH_QCOM depends
       hwrng: msm: switch Kconfig to ARCH_QCOM depends
       gpio: msm: switch Kconfig to ARCH_QCOM depends

  drivers/char/hw_random/Kconfig | 6 +++---
  drivers/gpio/Kconfig           | 2 +-
  drivers/gpu/drm/msm/Kconfig    | 2 +-
  drivers/power/reset/Kconfig    | 2 +-
  drivers/tty/serial/Kconfig     | 2 +-
  5 files changed, 7 insertions(+), 7 deletions(-)

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
