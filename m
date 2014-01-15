Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaAOQfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:35:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaAOQfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:35:10 -0500
Date: Wed, 15 Jan 2014 11:34:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: [PATCH] Add /sys/kernel/vmcoreinfo ABI documentation
Message-ID: <20140115163427.GA3180@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/sys/kernel/vmcoreinfo was introduced long back but there is no ABI
documentation. This patch adds the documentation.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/ABI/testing/sysfs-kernel-vmcoreinfo |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/Documentation/ABI/testing/sysfs-kernel-vmcoreinfo
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/Documentation/ABI/testing/sysfs-kernel-vmcoreinfo	2014-01-15 11:30:22.402206445 -0500
@@ -0,0 +1,14 @@
+What:		/sys/kernel/vmcoreinfo
+Date:		October 2007
+KernelVersion:	2.6.24
+Contact:	Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
+		Kexec Mailing List <kexec@lists.infradead.org>
+		Vivek Goyal <vgoyal@redhat.com>
+Description
+		Shows physical address and size of vmcoreinfo ELF note.
+		First value contains physical address of note in hex and
+		second value contains the size of note in hex. This ELF
+		note info is parsed by second kernel and exported to user
+		space as part of ELF note in /proc/vmcore file. This note
+		contains various information like struct size, symbol
+		values, page size etc.
