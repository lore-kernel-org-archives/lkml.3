Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3KFNsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:48:55 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43819 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab3KFNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:51 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v6 11/11] MAINTAINERS: add the maintainers for VFS hot tracking
Date: Wed,  6 Nov 2013 21:45:44 +0800
Message-Id: <1383745544-391-12-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-0928-0000-0000-00000355D236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

This patch adds maintainer information for VFS hot tracking
into the MAINTAINERS file.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ffcaf97..49ff6cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3387,6 +3387,18 @@ L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	fs/*
 
+VFS HOT TRACKING
+M:	Zhi Yong Wu <zwu.kernel@gmail.com>
+M:	Chandra Seetharaman <sekharan@us.ibm.com>
+L:	linux-fsdevel@vger.kernel.org
+T:	git git://github.com/wuzhy/kernel.git
+S:	Maintained
+F:	Documentation/filesystems/hot_tracking.txt
+F:	fs/hot_tracking.c
+F:	fs/hot_tracking.h
+F:	include/linux/hot_tracking.h
+F:	include/uapi/linux/hot_tracking.h
+
 FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 M:	Riku Voipio <riku.voipio@iki.fi>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.11.7

