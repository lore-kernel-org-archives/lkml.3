Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaKRKVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:21:30 -0500
Received: from mail.zhinst.com ([212.126.164.98]:45711 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaKRKV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:21:28 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>
Subject: [PATCH] drivers: Remove duplicate include of SOC driver configuration
Date: Tue, 18 Nov 2014 11:21:23 +0100
Message-Id: <1416306083-18460-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SOC driver configuration entry was added to drivers/Kconfig twice,
by commits 3a6e08218f36 ("soc: Introduce drivers/soc place-holder for
SOC specific drivers") and 41f93af900a2 ("soc: ti: add Keystone
Navigator QMSS driver"), respectively. Remove one of them.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sandeep Nair <sandeep_n@ti.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 1a693d3..622fa26 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -148,8 +148,6 @@ source "drivers/remoteproc/Kconfig"
 
 source "drivers/rpmsg/Kconfig"
 
-source "drivers/soc/Kconfig"
-
 source "drivers/devfreq/Kconfig"
 
 source "drivers/extcon/Kconfig"
-- 
2.0.1


