Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3CBBQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 20:16:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18175 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CBBQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 20:16:58 -0500
Date: Fri, 1 Mar 2013 20:16:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.9-rc1-tag
Message-ID: <20130302011647.GA12858@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.9-rc1-tag

which has <signed tag>
Bug-fixes:
 - Update the Xen ACPI memory and CPU hotplug locking mechanism.
 - Fix PAT issues wherein various applications would not start
 - Fix handling of multiple MSI as AHCI now does it.
 - Fix ARM compile failures.
</signed tag>

There is an oddity with this tag which is that the branch in which
this tag lives has this merged: 77be36de8b07027a70fbc8f02703ccd76cd16d09
(Merge tag 'stable/for-linus-3.9-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen)
to accomodate the changes you did "Fix up a few semantic conflicts with
the ACPI interface changes in drivers/xen/xen-acpi-{cpu,mem}hotplug.c."

No rebase thought - just a merge of that so that the patches compile cleanly
in the branch.

Please pull!

 arch/x86/pci/xen.c                 |  9 +++++++
 arch/x86/xen/enlighten.c           | 10 +++++++-
 drivers/xen/xen-acpi-cpuhotplug.c  | 34 +++++++++----------------
 drivers/xen/xen-acpi-memhotplug.c  | 52 +++++++++++++++++++-------------------
 drivers/xen/xenbus/xenbus_client.c |  1 +
 5 files changed, 57 insertions(+), 49 deletions(-)

Konrad Rzeszutek Wilk (2):
      xen/pat: Disable PAT using pat_enabled value.
      xen/pci: We don't do multiple MSI's.

Liu Jinsong (2):
      xen/acpi: xen memory hotplug minor updates
      xen/acpi: xen cpu hotplug minor updates

Steven Noonan (1):
      xenbus: fix compile failure on ARM with Xen enabled

