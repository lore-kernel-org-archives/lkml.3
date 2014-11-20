Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbaKTRJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:09:25 -0500
Received: from david.siemens.de ([192.35.17.14]:43856 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbaKTRCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:02:42 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v10 27/27] scripts/gdb: Define maintainer
Date: Thu, 20 Nov 2014 18:02:04 +0100
Message-Id: <d92098e7cf60d31ccd025e56d20c23917ccd0819.1416502923.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
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
index c444907..062db33 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4066,6 +4066,11 @@ W:	http://www.icp-vortex.com/
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
1.8.4.5

