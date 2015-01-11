Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbbAKMi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:38:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44611 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbAKMiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:38:25 -0500
From: Yaniv Gardi <ygardi@codeaurora.org>
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, santoshsy@gmail.com,
        linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org,
        ygardi@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org
Subject: [PATCH v6 0/4] *** add support for UFS in Qualcomm Technologies 
Date: Sun, 11 Jan 2015 14:38:05 +0200
Message-Id: <1420979889-22126-1-git-send-email-ygardi@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

Yaniv Gardi (4):
  phy: qcom-ufs: add support for 20nm phy
  scsi: ufs-qcom: add support for Qualcomm Technologies Inc platforms
  phy: qcom-ufs: add support for 14nm phy
  scsi: ufs-qcom-ice: add Inline Crypto Engine (ICE) support for UFS

 drivers/phy/Kconfig                 |    7 +
 drivers/phy/Makefile                |    3 +
 drivers/phy/phy-qcom-ufs-i.h        |  159 ++++++
 drivers/phy/phy-qcom-ufs-qmp-14nm.c |  201 +++++++
 drivers/phy/phy-qcom-ufs-qmp-14nm.h |  177 ++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.c |  257 +++++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.h |  235 ++++++++
 drivers/phy/phy-qcom-ufs.c          |  745 ++++++++++++++++++++++++
 drivers/scsi/ufs/Kconfig            |   25 +
 drivers/scsi/ufs/Makefile           |    2 +
 drivers/scsi/ufs/ufs-qcom-ice.c     |  520 +++++++++++++++++
 drivers/scsi/ufs/ufs-qcom-ice.h     |  113 ++++
 drivers/scsi/ufs/ufs-qcom.c         | 1058 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h         |  195 +++++++
 include/linux/phy/phy-qcom-ufs.h    |   59 ++
 15 files changed, 3756 insertions(+)
 create mode 100644 drivers/phy/phy-qcom-ufs-i.h
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.h
 create mode 100644 drivers/scsi/ufs/ufs-qcom.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom.h
 create mode 100644 include/linux/phy/phy-qcom-ufs.h

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
