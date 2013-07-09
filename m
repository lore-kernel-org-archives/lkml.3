Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3GIANr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:13:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab3GIANk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:13:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 0/8] ACPI / hotplug / PCI: Consolidation of handling notifications (in progress)
Date: Tue, 09 Jul 2013 02:01:55 +0200
Message-ID: <26431283.HJCKsss0rt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following is the current set of acpiphp updates targeted at the consolidation
of device notifications handling and removal of suprefluous infrastructure.
Still on top of 3.10 with ACPI+PM 3.11 material merged on top (I'll rebase it
on top of linux-pm.git/bleeding-edge eventually).

[1/8] Make bus registration and unregistration symmetric.  [Resend]
[2/8] Consolidate acpiphp_enumerate_slots().  [Resend]
[3/8] Fix error code path in register_slot().  [Resend]
[4/8] Introduce hotplug context objects for ACPI device objects corresponding
      to PCI hotplug devices.  [Update]
[5/8] Unified notify handler for hotplug events.  [Resend]
[6/8] Drop acpiphp_handle_to_bridge() and use context objects instead of it.
[7/8] Pass entire hotplug context objects (instead of their fields
      individually) to event handling work functions.
[8/8] Merge hotplug event handling functions.

Comments welcome.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

