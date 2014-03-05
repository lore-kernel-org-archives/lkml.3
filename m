Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaCEFl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 00:41:58 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46405 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750747AbaCEFl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 00:41:56 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: gregkh@linuxfoundation.org, joe@perches.com, davem@davemloft.net,
        m.chehab@samsung.com, swarren@nvidia.com, khali@linux-fr.org,
        linux-kernel@vger.kernel.org, sonic.zhang@analog.com,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] MAINTAINERS: blackfin: add git repository
Date: Wed,  5 Mar 2014 06:41:44 +0100
Message-Id: <1393998104-4180-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <5316B830.9060007@free-electrons.com>
References: <5316B830.9060007@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the git repository currently in use for
blackfin architecture development.

This information was obtained from Steven Miao.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c6d0e93eff62..d00f5ae83236 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1737,6 +1737,7 @@ F:	include/uapi/linux/bfs_fs.h
 BLACKFIN ARCHITECTURE
 M:	Steven Miao <realmz6@gmail.com>
 L:	adi-buildroot-devel@lists.sourceforge.net
+T:	git git://git.code.sf.net/p/adi-linux/code
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	arch/blackfin/
-- 
1.8.3.2

