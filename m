Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaLABVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:21:05 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:57949 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbaLABVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:21:02 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: netdev@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        =?UTF-8?q?Piotr=20Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uapi: fix to export linux/vm_sockets.h
Date: Mon,  1 Dec 2014 10:16:17 +0900
Message-Id: <1417396577-32499-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A typo "header=y" was introduced by commit 7071cf7fc435
(uapi: add missing network related headers to kbuild).

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
---

 include/uapi/linux/Kbuild | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 4c94f31..8523f9b 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -427,7 +427,7 @@ header-y += virtio_net.h
 header-y += virtio_pci.h
 header-y += virtio_ring.h
 header-y += virtio_rng.h
-header=y += vm_sockets.h
+header-y += vm_sockets.h
 header-y += vt.h
 header-y += wait.h
 header-y += wanrouter.h
-- 
1.9.1

