Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3JLU5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 16:57:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54949 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753750Ab3JLU5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 16:57:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.12-rc5
Date: Sat, 12 Oct 2013 23:09:03 +0200
Message-ID: <2749952.3MjEW76cA8@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.12-rc5

to receive ACPI and power management fixes for v3.12-rc5 with
top-most commit 2c5bfce855ead529e2ea6f33757aa26a651d4460

  Merge branch 'acpi-pci-hotplug'

on top of commit d0e639c9e06d44e713170031fe05fb60ebe680af

  Linux 3.12-rc4

These fix two recent bugs in ACPIPHP (ACPI-based PCI hotplug) and
update a bunch of web links and e-mail addresses in MAINTAINERS, docs
and Kconfig that either are stale or will expire soon.

Specifics:

 - The WARN_ON() in acpiphp_enumerate_slots() triggers as a false
   positive in some cases, so drop it.

 - Add a missing pci_dev_put() to an error code path in
   acpiphp_enumerate_slots().

 - Replace my old e-mail address that's going to expire with a new one.

 - Update ACPI web links and git tree information in MAINTAINERS.

 - Update links to the Linux-ACPI project's page in MAINTAINERS.

 - Update some stale links and e-mail addresses under Documentation
   and in the ACPI Kconfig file.

Thanks!


---------------

Rafael J. Wysocki (6):
      MAINTAINERS / Documentation: Update Rafael's e-mail address
      MAINTAINERS / ACPI: Update links and git tree information
      MAINTAINERS / ACPI: Update links to the Linux-ACPI project web page
      ACPI / PM / Documentation: Replace outdated project links and addresses
      ACPI / hotplug / PCI: Fix error code path in acpiphp_enumerate_slots()
      ACPI / hotplug / PCI: Drop WARN_ON() from acpiphp_enumerate_slots()

---------------

 Documentation/ABI/stable/sysfs-bus-usb        |    8 +++----
 Documentation/ABI/testing/sysfs-devices-power |   32 ++++++++++++-------------
 Documentation/ABI/testing/sysfs-power         |   22 ++++++++---------
 Documentation/acpi/dsdt-override.txt          |    2 +-
 MAINTAINERS                                   |   26 ++++++++++----------
 drivers/acpi/Kconfig                          |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c            |    8 ++++---
 7 files changed, 51 insertions(+), 49 deletions(-)

