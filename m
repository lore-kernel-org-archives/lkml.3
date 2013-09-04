Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584Ab3IDJAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:00:25 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:39359 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934451Ab3IDJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:00:22 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2013 05:00:22 EDT
Subject: [PATCH] Add an entry in MAINTAINERS for VMware's hypervisor
 interface
From: Alok Kataria <akataria@vmware.com>
Reply-To: Alok Kataria <akataria@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Doug Covelli <dcovelli@vmware.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Sep 2013 14:23:41 +0530
Message-ID: <1378284821.9739.7404.camel@akataria-dtop.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

This change adds an entry to the maintainers file to explicitly state
that any changes to vmware.c should be sent to the authors of the file
as well.

If you are thinking why do this now, off late we have seen quite a few
changes that touched the "arch/x86/kernel/cpu/vmware.c" file but were
not directed to me, someone else made me aware of those changes. It
could be that my use of different SOB lines "Alok N Kataria" vs "Alok
Kataria" confuses get_maintainer.pl, but adding this entry in
MAINTAINERS should solve the problem at hand. For one of the changes
[1], I did verify that get_maintainer.pl, now expectedly includes me in
the cc list.

Thanks,
Alok 

[1] http://marc.info/?l=linux-kernel&m=137571112610984&w=2

>From : Alok Kataria <akataria@vmware.com>

Add an entry in MAINTAINERS file to reflect the authors of a file.

Signed-off-by: Alok Kataria <akataria@vmware.com>

Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS	2013-09-04 14:07:34.404027068 +0530
+++ linux-2.6/MAINTAINERS	2013-09-04 14:20:39.714026943 +0530
@@ -9038,6 +9038,12 @@
 F:	drivers/vme/
 F:	include/linux/vme*
 
+VMWARE HYPERVISOR INTERFACE
+M: Alok Kataria <akataria@vmware.com>
+L: virtualization@lists.linux-foundation.org
+S: Supported
+F: arch/x86/kernel/cpu/vmware.c
+
 VMWARE VMXNET3 ETHERNET DRIVER
 M:	Shreyas Bhatewara <sbhatewara@vmware.com>
 M:	"VMware, Inc." <pv-drivers@vmware.com>



