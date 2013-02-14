Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534Ab3BNSLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:11:51 -0500
Received: from mail-qa0-f73.google.com ([209.85.216.73]:49857 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347Ab3BNSLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:11:50 -0500
Date: Thu, 14 Feb 2013 10:46:22 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel J Blueman <daniel@quora.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI update for v3.8
Message-ID: <20130214174622.GA19787@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is another fix for v3.8.  It fixes an oops that happens when a
Thunderbolt adapter is unplugged (remove device, poll for PME events on
no-longer-existing device, oops).

Bjorn


The following changes since commit 444ee9bd3d0fa78317c6127c961af5accf50038b:

  PCI: remove depends on CONFIG_EXPERIMENTAL (2013-01-17 16:22:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/3.8-pci-fixes-3

for you to fetch changes up to 249bfb83cf8ba658955f0245ac3981d941f746ee:

  PCI/PM: Clean up PME state when removing a device (2013-02-13 11:58:02 -0700)

----------------------------------------------------------------
PCI update for v3.8:

  Hotplug
    PCI/PM: Clean up PME state when removing a device

----------------------------------------------------------------
Rafael J. Wysocki (1):
      PCI/PM: Clean up PME state when removing a device

 drivers/pci/remove.c | 2 ++
 1 file changed, 2 insertions(+)
