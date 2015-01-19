Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbbASS1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:27:19 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41433 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbASS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:27:17 -0500
Date: Mon, 19 Jan 2015 12:27:15 -0600 (CST)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, lina.iyer@linaro.org,
        skannan@codeaurora.org, ohaugan@codeaurora.org, markivx@codeaurora.org
Subject: [GIT PULL] qcom SoC changes for v3.20
Message-ID: <alpine.DEB.2.02.1501191226010.2973@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.20

for you to fetch changes up to ae0a6075c046f9c8dbac18f53a779592f97b402e:

   soc: qcom: scm: Clarify boot interface (2015-01-19 11:55:12 -0600)

----------------------------------------------------------------
Qualcomm ARM Based SoC Updates for v3.20

* Moved scm support into drivers/soc/qcom (allows for use by drivers)
* Various bug fixes and minor feature additions to scm code
* Added big-endian support to debug MSM uart
* Added big-endian support to ARCH_QCOM

----------------------------------------------------------------
Lina Iyer (2):
       ARM: qcom: Add SCM warmboot flags for quad core targets.
       soc: qcom: scm: Move scm-boot files to drivers/soc and include/soc

Olav Haugan (1):
       ARM: qcom: scm: Add logging of actual return code from scm call

Saravana Kannan (1):
       ARM: qcom: scm: Add API to query for service/command availability.

Stephen Boyd (9):
       ARM: debug: Update MSM and QCOM DEBUG_LL help
       ARM: debug: msm: Support big-endian CPUs
       ARM: qcom: Select ARCH_SUPPORTS_BIG_ENDIAN
       ARM: qcom: scm: Fix incorrect cache invalidation
       ARM: qcom: scm: Get cacheline size from CTR
       ARM: qcom: scm: Add a feat version query API
       soc: qcom: scm: Move the scm driver to drivers/soc/qcom
       soc: qcom: scm: Add atomic SCM APIs
       soc: qcom: scm: Clarify boot interface

Vikram Mulukutla (1):
       ARM: qcom: scm: Flush the command buffer only instead of the entire cache

  arch/arm/Kconfig.debug                             |   5 +-
  arch/arm/include/debug/msm.S                       |   6 +
  arch/arm/mach-qcom/Kconfig                         |   4 +-
  arch/arm/mach-qcom/Makefile                        |   3 -
  arch/arm/mach-qcom/platsmp.c                       |   2 +-
  drivers/soc/qcom/Kconfig                           |   2 +
  drivers/soc/qcom/Makefile                          |   2 +
  .../arm/mach-qcom => drivers/soc/qcom}/scm-boot.c  |   6 +-
  {arch/arm/mach-qcom => drivers/soc/qcom}/scm.c     | 162 ++++++++++++++++++---
  .../arm/mach-qcom => include/soc/qcom}/scm-boot.h  |   4 +-
  {arch/arm/mach-qcom => include/soc/qcom}/scm.h     |   8 +-
  11 files changed, 173 insertions(+), 31 deletions(-)
  rename {arch/arm/mach-qcom => drivers/soc/qcom}/scm-boot.c (91%)
  rename {arch/arm/mach-qcom => drivers/soc/qcom}/scm.c (62%)
  rename {arch/arm/mach-qcom => include/soc/qcom}/scm-boot.h (87%)
  rename {arch/arm/mach-qcom => include/soc/qcom}/scm.h (70%)

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
