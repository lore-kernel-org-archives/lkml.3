Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3IZOzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:55:03 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36191 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3IZOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:00 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 00/27] mmc: Remove the deprecated APIs mmc_suspend|resume_host
Date: Thu, 26 Sep 2013 16:54:25 +0200
Message-Id: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is removing the use of the deprecated APIs from each and every
host driver. The final patch then removes the acutal APIs from mmc core.

I hope to collect acks from each maintainer and then try to merge this through
Chris tree, unless anybody has a better suggestion for the way forward.

Ulf Hansson (27):
  mmc: atmel-mci: Remove redundant suspend and resume callbacks
  mmc: au1xmmc: Move away from using deprecated APIs
  mmc: bfin_sdh: Move away from using deprecated APIs
  mmc: cb710: Move away from using deprecated APIs
  mmc: davinci_mmc: Move away from using deprecated APIs
  mmc: dw_mmc: Move away from using deprecated APIs
  mmc: jz4740: Move away from using deprecated APIs
  mmc: msm_sdcc: Move away from using deprecated APIs
  mmc: mvsdio: Remove redundant suspend and resume callbacks
  mmc: vub300: Remove redundant suspend and resume callbacks
  mmc: sdhci: Move away from using deprecated APIs
  mmc: tifm_sd: Move away from using deprecated APIs
  mmc: omap: Remove redundant suspend and resume callbacks
  mmc: omap_hsmmc: Move away from using deprecated APIs
  mmc: mxs-mmc: Move away from using deprecated APIs
  mmc: mxcmmc: Move away from using deprecated APIs
  mmc: wmt-sdmmc: Move away from using deprecated APIs
  mmc: s3cmci: Remove redundant suspend and resume callbacks
  mmc: pxamci: Remove redundant suspend and resume callbacks
  mmc: wbsd: Move away from using deprecated APIs
  mmc: rtsx: Remove redundant suspend and resume callbacks
  mmc: sdricoh_cs: Move away from using deprecated APIs
  mmc: sh_mmcif: Move away from using deprecated APIs
  mmc: tmio: Move away from using deprecated APIs
  mmc: via-sdmmc: Move away from using deprecated APIs
  mmc: mmci: Move away from using deprecated APIs
  mmc: core: Remove deprecated mmc_suspend|resume_host APIs

 drivers/mmc/core/core.c           |   22 -------------
 drivers/mmc/host/atmel-mci.c      |   61 -------------------------------------
 drivers/mmc/host/au1xmmc.c        |    7 +----
 drivers/mmc/host/bfin_sdh.c       |   12 +-------
 drivers/mmc/host/cb710-mmc.c      |   10 +-----
 drivers/mmc/host/davinci_mmc.c    |   26 +++-------------
 drivers/mmc/host/dw_mmc.c         |   21 -------------
 drivers/mmc/host/jz4740_mmc.c     |    4 ---
 drivers/mmc/host/mmci.c           |   17 +++--------
 drivers/mmc/host/msm_sdcc.c       |   27 ++--------------
 drivers/mmc/host/mvsdio.c         |   29 ------------------
 drivers/mmc/host/mxcmmc.c         |   12 ++------
 drivers/mmc/host/mxs-mmc.c        |   12 ++------
 drivers/mmc/host/omap.c           |   53 --------------------------------
 drivers/mmc/host/omap_hsmmc.c     |   37 ++--------------------
 drivers/mmc/host/pxamci.c         |   32 -------------------
 drivers/mmc/host/rtsx_pci_sdmmc.c |   33 --------------------
 drivers/mmc/host/s3cmci.c         |   29 ------------------
 drivers/mmc/host/sdhci.c          |   20 ++----------
 drivers/mmc/host/sdricoh_cs.c     |    3 --
 drivers/mmc/host/sh_mmcif.c       |   10 ++----
 drivers/mmc/host/tifm_sd.c        |    4 +--
 drivers/mmc/host/tmio_mmc_pio.c   |    9 ++----
 drivers/mmc/host/via-sdmmc.c      |    7 +----
 drivers/mmc/host/vub300.c         |   30 ------------------
 drivers/mmc/host/wbsd.c           |   33 +++-----------------
 drivers/mmc/host/wmt-sdmmc.c      |   27 ++++++----------
 include/linux/mmc/host.h          |    3 --
 28 files changed, 46 insertions(+), 544 deletions(-)

-- 
1.7.9.5

