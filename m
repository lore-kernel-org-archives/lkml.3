Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3IEFEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:04:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35426 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3IEFD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:03:58 -0400
Date: Wed, 4 Sep 2013 22:03:40 -0700
From: tip-bot for Alok Kataria <tipbot@zytor.com>
Message-ID: <tip-4488e09b4582c3d9cae1601351e26584e208d877@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akataria@vmware.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akataria@vmware.com, hpa@linux.intel.com
In-Reply-To: <1378284821.9739.7404.camel@akataria-dtop.eng.vmware.com>
References: <1378284821.9739.7404.camel@akataria-dtop.eng.vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, doc: Add an entry in MAINTAINERS for arch/
 x86/kernel/cpu/vmware.c
Git-Commit-ID: 4488e09b4582c3d9cae1601351e26584e208d877
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 04 Sep 2013 22:03:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4488e09b4582c3d9cae1601351e26584e208d877
Gitweb:     http://git.kernel.org/tip/4488e09b4582c3d9cae1601351e26584e208d877
Author:     Alok Kataria <akataria@vmware.com>
AuthorDate: Wed, 4 Sep 2013 14:23:41 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 4 Sep 2013 22:00:04 -0700

x86, doc: Add an entry in MAINTAINERS for arch/x86/kernel/cpu/vmware.c

Add an entry in MAINTAINERS file to reflect the maintainers of this
file.

Signed-off-by: Alok Kataria <akataria@vmware.com>
Link: http://lkml.kernel.org/r/1378284821.9739.7404.camel@akataria-dtop.eng.vmware.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[ hpa: fixed tabs vs spaces ]
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index defc053..fba8134 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9016,6 +9016,12 @@ F:	drivers/staging/vme/
 F:	drivers/vme/
 F:	include/linux/vme*
 
+VMWARE HYPERVISOR INTERFACE
+M:	Alok Kataria <akataria@vmware.com>
+L:	virtualization@lists.linux-foundation.org
+S:	Supported
+F:	arch/x86/kernel/cpu/vmware.c
+
 VMWARE VMXNET3 ETHERNET DRIVER
 M:	Shreyas Bhatewara <sbhatewara@vmware.com>
 M:	"VMware, Inc." <pv-drivers@vmware.com>
