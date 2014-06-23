Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaFWNFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbaFWNFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 74/93] usb: cdc-wdm: export cdc-wdm uapi header
Date: Mon, 23 Jun 2014 14:02:53 +0100
Message-Id: <1403528592-2163-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 7d1896360f4d055d68565ef8ed56a677580f1a39 upstream.

The include/uapi/linux/usb/cdc-wdm.h header defines cdc-wdm
userspace APIs and should be exported by make headers_install.

Fixes: 3edce1cf813a ("USB: cdc-wdm: implement IOCTL_WDM_MAX_COMMAND")
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

