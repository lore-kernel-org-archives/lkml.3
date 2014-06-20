Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966572AbaFTJGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:06:06 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43503 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860AbaFTJGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:06:00 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andreas.noever@gmail.com, spk.linux@gmail.com
Subject: [PATCH 6/6] thunderbolt: Staticize nhi_ids
Date: Fri, 20 Jun 2014 14:32:34 +0530
Message-Id: <1403254954-14429-6-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
References: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'nhi_ids' is local to this file.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thunderbolt/nhi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 0fc137af89f5..2054fbf8b382 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -632,7 +632,7 @@ static const struct dev_pm_ops nhi_pm_ops = {
 	.restore_noirq = nhi_resume_noirq,
 };
 
-struct pci_device_id nhi_ids[] = {
+static struct pci_device_id nhi_ids[] = {
 	/*
 	 * We have to specify class, the TB bridges use the same device and
 	 * vendor (sub)id.
-- 
1.7.9.5

