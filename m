Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3BVLde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 06:33:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab3BVLdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 06:33:33 -0500
Message-ID: <1361532811.27043.2.camel@f16>
Subject: [PATCH] Clean-up:  Fix incorrect path to header file
From: Jonathan Brassow <jbrassow@redhat.com>
To: linux-kernel@vger.kernel.org
Date: Fri, 22 Feb 2013 05:33:31 -0600
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean-up:  Fix incorrect path to header file

Commit af170c5 (originally introduced in v3.8-rc1) moved some header
files around and forgot to adjust the path to one of those.  Thus the
header cannot be found, the macros are not defined and the kernel will
not compile.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/arch/x86/include/uapi/asm/msr.h
===================================================================
--- linux-upstream.orig/arch/x86/include/uapi/asm/msr.h
+++ linux-upstream/arch/x86/include/uapi/asm/msr.h
@@ -1,7 +1,7 @@
 #ifndef _UAPI_ASM_X86_MSR_H
 #define _UAPI_ASM_X86_MSR_H
 
-#include <asm/msr-index.h>
+#include <uapi/asm/msr-index.h>
 
 #ifndef __ASSEMBLY__
 


