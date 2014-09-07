Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaIGSA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:00:29 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:45175 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaIGSA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:00:27 -0400
Date: Sun, 7 Sep 2014 20:00:23 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] Extending the first version of the patch to the
 entire directory
Message-ID: <20140907180023.GA1849@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 and 2 are straight forward extension from the previous version
of the patch.

Patch 3 introduces checkpatch warning due to lines surpassing 80
characters. Another warning concerning too many preceding tabs
is not fixed either.

Patch 4 are less straight forward similar modifications
the modification made to ibmphp_res.c change the value of len_tmp
when the first condition in if statement is not met.
I wasn't quite sure how to solve elegantly the checkpatch error for
slot.c, I chose to use a label and gotos since it was already used
and allowed for a slight code factorisation. This being my first patch I
understand that this may not be the best solution.



Quentin Lambert (4):
  PCI: fix a missing space coding style issue
  PCI: fix a simple if coding style issue
  PCI: remove assignement from if conditions
  PCI: remove assignement in non straight forward if condition

 drivers/pci/hotplug/acpi_pcihp.c        |  3 ++-
 drivers/pci/hotplug/acpiphp_ibm.c       |  2 +-
 drivers/pci/hotplug/cpci_hotplug_core.c | 13 ++++++----
 drivers/pci/hotplug/cpcihp_generic.c    | 28 ++++++++++-----------
 drivers/pci/hotplug/cpcihp_zt5550.c     | 44 ++++++++++++++++-----------------
 drivers/pci/hotplug/cpqphp.h            |  2 +-
 drivers/pci/hotplug/cpqphp_core.c       |  3 +--
 drivers/pci/hotplug/cpqphp_ctrl.c       | 19 ++++++--------
 drivers/pci/hotplug/cpqphp_nvram.c      | 13 ++++------
 drivers/pci/hotplug/ibmphp_core.c       | 19 ++++++++------
 drivers/pci/hotplug/ibmphp_ebda.c       |  3 +--
 drivers/pci/hotplug/ibmphp_hpc.c        |  3 +--
 drivers/pci/hotplug/ibmphp_pci.c        |  6 +++--
 drivers/pci/hotplug/ibmphp_res.c        | 43 ++++++++++++++++++++++----------
 drivers/pci/hotplug/shpchp_ctrl.c       | 12 ++++++---
 drivers/pci/hotplug/shpchp_hpc.c        |  3 ++-
 drivers/pci/pci.c                       | 19 +++++++++++---
 drivers/pci/slot.c                      | 12 +++++++--
 18 files changed, 143 insertions(+), 104 deletions(-)

-- 
1.9.1

