Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaFWIko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55592 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/111] usb: cdc-wdm: export cdc-wdm uapi header
Date: Mon, 23 Jun 2014 10:31:24 +0200
Message-Id: <a9fad769455dad571ee526bca5a7f52c5dbbaf81.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7d1896360f4d055d68565ef8ed56a677580f1a39 upstream.

The include/uapi/linux/usb/cdc-wdm.h header defines cdc-wdm
userspace APIs and should be exported by make headers_install.

Fixes: 3edce1cf813a ("USB: cdc-wdm: implement IOCTL_WDM_MAX_COMMAND")
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/linux/usb/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/usb/Kbuild b/include/uapi/linux/usb/Kbuild
index 6cb4ea826834..4cc4d6e7e523 100644
--- a/include/uapi/linux/usb/Kbuild
+++ b/include/uapi/linux/usb/Kbuild
@@ -1,6 +1,7 @@
 # UAPI Header export list
 header-y += audio.h
 header-y += cdc.h
+header-y += cdc-wdm.h
 header-y += ch11.h
 header-y += ch9.h
 header-y += functionfs.h
-- 
2.0.0

