Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaJORFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:05:52 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:43453 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJORFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:05:50 -0400
Subject: [PATCH v1 01/10] audit: Remove "weak" from
 audit_classify_compat_syscall() declaration
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:05:47 -0600
Message-ID: <20141015170547.4063.99053.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one audit_classify_compat_syscall() definition, so it doesn't
need to be weak.

Remove the "weak" attribute from the audit_classify_compat_syscall()
declaration.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: AKASHI Takahiro <takahiro.akashi@linaro.org>
CC: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22cfddb75566..1b6098beb46b 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -86,7 +86,7 @@ extern unsigned compat_dir_class[];
 extern unsigned compat_chattr_class[];
 extern unsigned compat_signal_class[];
 
-extern int __weak audit_classify_compat_syscall(int abi, unsigned syscall);
+extern int audit_classify_compat_syscall(int abi, unsigned syscall);
 
 /* audit_names->type values */
 #define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */

