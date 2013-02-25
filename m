Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab3BYWUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:20:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3BYWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 53/58] sparc64: Add missing HAVE_ARCH_TRANSPARENT_HUGEPAGE.
Date: Mon, 25 Feb 2013 14:19:49 -0800
Message-Id: <20130225221647.508572244@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit b9156ebb7beef015745f917f373abc137efc3400 ]

This got missed in the cleanups done for the S390 THP
support.

CC: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -61,6 +61,7 @@ config SPARC64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_SYSCALL_WRAPPERS
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_SYSCALL_TRACEPOINTS


