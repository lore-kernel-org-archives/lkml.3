Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbaKTTsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:48:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35490 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTTsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:48:16 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/3] qcom_rpm: add support for IPQ8064 resources
Date: Thu, 20 Nov 2014 13:41:22 -0600
Message-Id: <1416512485-7292-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IPQ8064 SoC has several Resource Power Manager (RPM) controlled resources:
four regulators (two SMB208s, each controlling two regulators) and two fabric
clocks for the Network Subsystem (NSS).  This patchset adds the appropriate
definitions for these resources, and extends the existing RPM regulator driver
to support the SMB208.

This patchset is based ontop of v7 of Bjorne Andersson's RPM patchset [1].

1: http://lkml.kernel.org/r/1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com

Josh Cartwright (3):
  mfd: devicetree: qcom_rpm: document IPQ8064 resources
  mfd: qcom_rpm: add support for IPQ8064
  regulator: rpm: add support for RPM-controller SMB208

 Documentation/devicetree/bindings/mfd/qcom-rpm.txt |  6 +++-
 drivers/mfd/qcom_rpm.c                             | 41 ++++++++++++++++++++++
 drivers/regulator/qcom_rpm-regulator.c             | 19 ++++++++++
 include/dt-bindings/mfd/qcom-rpm.h                 |  6 ++++
 4 files changed, 71 insertions(+), 1 deletion(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

