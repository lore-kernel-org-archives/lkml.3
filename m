Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881AbaE3QnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:43:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60182 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399AbaE3QnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:43:15 -0400
Date: Fri, 30 May 2014 11:43:13 -0500 (CDT)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [GIT PULL] qcom SoC changes for v3.16-2
Message-ID: <alpine.DEB.2.00.1405301142280.5291@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 87cfb00d666cca3abf36f755279cde1b27b9c377:

   ARM: qcom: Select PINCTRL by default for ARCH_QCOM (2014-05-22 11:50:42 -0500)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.16-2

for you to fetch changes up to 2f528dd3b30c4351c0ece73b8bdc39753c02003b:

   ARM: debug: qcom: add UART addresses to Kconfig help for APQ8084 (2014-05-29 11:14:28 -0500)

----------------------------------------------------------------
Qualcomm ARM Based SoC Updates for v3.16-2

* Updated Kconfig DEBUG_QCOM_UARTDM help to include APQ8084 info

----------------------------------------------------------------
Georgi Djakov (1):
       ARM: debug: qcom: add UART addresses to Kconfig help for APQ8084

  arch/arm/Kconfig.debug | 1 +
  1 file changed, 1 insertion(+)

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
