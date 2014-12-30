Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaL3Nut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 08:50:49 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:37712 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaL3Nur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 08:50:47 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Sandeep Nair <sandeep_n@ti.com>, Kumar Gala <galak@codeaurora.org>
Subject: [PATCH] soc: Remove duplicate Kconfig include
Date: Tue, 30 Dec 2014 08:50:24 -0500
Message-Id: <1419947424-9555-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3a6e08218f36baa9c49282ad2fe0dfbf001d8f23
("soc: Introduce drivers/soc place-holder for SOC specific drivers")
added a duplicate source for soc Kconfig, which had already been
introduced by commit 41f93af900a20d1a0a358b522b5129c89677e9dc
("soc: ti: add Keystone Navigator QMSS driver").

Cc: Sandeep Nair <sandeep_n@ti.com>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 694d5a7..2683e63 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -150,8 +150,6 @@ source "drivers/remoteproc/Kconfig"
 
 source "drivers/rpmsg/Kconfig"
 
-source "drivers/soc/Kconfig"
-
 source "drivers/devfreq/Kconfig"
 
 source "drivers/extcon/Kconfig"
-- 
2.2.1

