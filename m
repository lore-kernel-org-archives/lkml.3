Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaGKDjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 23:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaGKDjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 23:39:13 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Eric Paris <eparis@redhat.com>, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] [RFC] audit: add AUDIT_ARCH_X86_X32 arch definition
Date: Thu, 10 Jul 2014 23:38:12 -0400
Message-Id: <b6655cee4250a69330ecbc6657a4df0d52ebd7da.1405023592.git.rgb@redhat.com>
In-Reply-To: <cover.1405023592.git.rgb@redhat.com>
References: <cover.1405023592.git.rgb@redhat.com>
In-Reply-To: <cover.1405023592.git.rgb@redhat.com>
References: <cover.1405023592.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a definition for 32-bit native system calls under 64-bit x86 architectures.
This is distict from 32-bit emulation under 64-bit x86 architectures.

Cc: Paul Moore <pmoore@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <aviro@redhat.com>
Cc: Will Drewry <wad@chromium.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index e15d6fc..4f5607f 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -374,6 +374,7 @@ enum {
 #define AUDIT_ARCH_SPARC	(EM_SPARC)
 #define AUDIT_ARCH_SPARC64	(EM_SPARCV9|__AUDIT_ARCH_64BIT)
 #define AUDIT_ARCH_X86_64	(EM_X86_64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
+#define AUDIT_ARCH_X86_X32	(EM_X86_64|__AUDIT_ARCH_LE)
 
 #define AUDIT_PERM_EXEC		1
 #define AUDIT_PERM_WRITE	2
-- 
1.7.1

