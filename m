Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbbAVTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:25:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47641 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbbAVTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:25:56 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH] PCI: xgene: Include clk.h instead of clk-private.h
Date: Thu, 22 Jan 2015 11:25:54 -0800
Message-Id: <1421954754-3217-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc0.46.gbe498cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver should be including clk.h as it's a clock consumer,
not a clock provider that needs to register clocks early.

Cc: Tanmay Inamdar <tinamdar@apm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/pci/host/pci-xgene.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-xgene.c b/drivers/pci/host/pci-xgene.c
index b1d0596457c5..fdb348d3ccd3 100644
--- a/drivers/pci/host/pci-xgene.c
+++ b/drivers/pci/host/pci-xgene.c
@@ -16,7 +16,7 @@
  * GNU General Public License for more details.
  *
  */
-#include <linux/clk-private.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

