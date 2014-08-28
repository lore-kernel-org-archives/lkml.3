Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaH1PTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:19:55 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:56263
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbaH1PTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:19:53 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        m.chehab@samsung.com, davem@davemloft.net, crope@iki.fi
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add entry for Kernel Selftest Framework
Date: Thu, 28 Aug 2014 09:19:49 -0600
Message-Id: <1409239189-22878-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry for Kernel Selftest Framework. Individual tests
continue to be maintained by the maintainers for those areas.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ff06de..5aaaeab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5209,6 +5209,13 @@ F:	include/linux/lockd/
 F:	include/linux/sunrpc/
 F:	include/uapi/linux/sunrpc/
 
+KERNEL SELFTEST FRAMEWORK
+M:	Shuah Khan <shuahkh@osg.samsung.com>
+L:	linux-api@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/shuah/linux-kselftest
+S:	Maintained
+F:	tools/testing/selftests
+
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Gleb Natapov <gleb@kernel.org>
 M:	Paolo Bonzini <pbonzini@redhat.com>
-- 
1.9.1

