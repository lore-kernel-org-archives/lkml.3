Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaHDS7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:59:30 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43243 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaHDS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:59:28 -0400
Date: Mon, 4 Aug 2014 20:59:23 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Fixing checkpatch errors and warnings for PCI hotplug
Message-ID: <20140804185923.GA4185@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 and 2 fix checkpatch coding style warnings.

Patch 3 fixes chechpatch errors due to assignement
in if conditions.


Quentin Lambert (3):
  PCI hotplug: fix a missing space coding style issue
  PCI hotplug: fix a simple if coding style issue
  PCI hotplug: remove assignement from if conditions

 drivers/pci/hotplug/acpi_pcihp.c    |  3 ++-
 drivers/pci/hotplug/cpcihp_zt5550.c | 42 ++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 22 deletions(-)

-- 
1.9.1

