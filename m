Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaBRCJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:09:29 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54981 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaBRCJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:09:27 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 18 Feb 2014 11:10:41 +0900
Message-Id: <20140218021041.14164.56411.sendpatchset@w520>
Subject: [PATCH v2 00/08] PCI: rcar: Recent driver patches from Ben Dooks and me (V2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: rcar: Recent driver patches from Ben Dooks and me (V2)

[PATCH 01/08] PCI: rcar: check platform_get_irq() return code
[PATCH v2 02/08] PCI: rcar: add error interrupt handling
[PATCH 03/08] PCI: rcar: fix bridge logic configuration accesses
[PATCH v3 04/08] PCI: rcar: Register each instance independently
[PATCH v2 05/08] PCI: rcar: Break out window size handling
[PATCH v2 06/08] PCI: rcar: Add DMABOUNCE support
[PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM
[PATCH 08/08] PCI: rcar: Make the Kconfig dependencies more generic

These patches update the pci-rcar-gen2.c driver with patches from
Ben Dooks and me. The first 3 are written by Ben (thanks!) and are
included here to show what I would like to have merged and what I
rebased my patches on. The following 4 are written by me.

Patch 1-3:
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Patch 4-8:
Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V1 of this series:
 - Updated [4/8] from v2 to v3 to fix init section issues, thanks Bjorn!

 Written against renesas.git tag renesas-devel-v3.14-rc3-20140217

 drivers/pci/host/Kconfig         |    5 
 drivers/pci/host/pci-rcar-gen2.c |  449 ++++++++++++++++++++++++++++++++------
 2 files changed, 387 insertions(+), 67 deletions(-)
