Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbbA2Gxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:53:50 -0500
Received: from david.siemens.de ([192.35.17.14]:58352 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbbA2Gxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:53:49 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v11 27/28] scripts/gdb: Define maintainer
Date: Thu, 29 Jan 2015 07:46:46 +0100
Message-Id: <44aa649fa546e27244d467257999e3e7e60fbd2b.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm proposing myself for keeping an eye on these scripts and integrating
contributions.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ebb056..3570313 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4164,6 +4164,11 @@ W:	http://www.icp-vortex.com/
 S:	Supported
 F:	drivers/scsi/gdt*
 
+GDB KERNEL DEBUGGING HELPER SCRIPTS
+M:	Jan Kiszka <jan.kiszka@siemens.com>
+S:	Supported
+F:	scripts/gdb/
+
 GEMTEK FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
2.1.4

