Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbbAHWzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:55:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43594 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbbAHWy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:54:59 -0500
From: Andy Gross <agross@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 0/2] Add Qualcomm TCSR driver
Date: Thu,  8 Jan 2015 16:52:55 -0600
Message-Id: <1420757577-20425-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a driver for the TCSR (Top Control and Status Register)
block that is present in the IPQ8064, APQ8064, and some later processors.  The
TCSR is responsible for accessing configuration and mux settings for a variety
of peripherals.

The initial version of this driver exposes configuration settings for the USB
PHY selection and ADM DMA CRCI muxing.

Andy Gross (2):
  soc: qcom: Add TCSR driver
  soc: qcom: Add device tree binding for TCSR

 .../devicetree/bindings/soc/qcom/qcom,tcsr.txt     |   33 ++++++++
 drivers/soc/qcom/Kconfig                           |    7 ++
 drivers/soc/qcom/Makefile                          |    1 +
 drivers/soc/qcom/qcom_tcsr.c                       |   83 ++++++++++++++++++++
 include/dt-bindings/soc/qcom,tcsr.h                |   34 ++++++++
 include/soc/qcom/qcom_tcsr.h                       |   21 +++++
 6 files changed, 179 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,tcsr.txt
 create mode 100644 drivers/soc/qcom/qcom_tcsr.c
 create mode 100644 include/dt-bindings/soc/qcom,tcsr.h
 create mode 100644 include/soc/qcom/qcom_tcsr.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

