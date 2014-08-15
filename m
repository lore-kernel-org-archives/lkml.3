Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaHOQsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:48:50 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41252 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaHOQst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:49 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 09/10] lustre: Add MAINTAINERS entry
Date: Fri, 15 Aug 2014 12:48:14 -0400
Message-Id: <1408121295-29115-10-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just add the entry with some info.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e2eb4c..369183b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8646,6 +8646,14 @@ W:	http://www.lirc.org/
 S:	Odd Fixes
 F:	drivers/staging/media/lirc/
 
+STAGING - LUSTRE PARALLEL FILESYSTEM
+M:	Oleg Drokin <oleg.drokin@intel.com>
+M:	Andreas Dilger <andreas.dilger@intel.com>
+L:	HPDD-discuss@lists.01.org (moderated for non-subscribers)
+W:	http://lustre.opensfs.org/
+S:	Maintained
+F:	drivers/staging/lustre
+
 STAGING - NVIDIA COMPLIANT EMBEDDED CONTROLLER INTERFACE (nvec)
 M:	Julian Andres Klode <jak@jak-linux.org>
 M:	Marc Dietrich <marvin24@gmx.de>
-- 
1.9.3

