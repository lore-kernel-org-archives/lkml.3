Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaAROfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 09:35:18 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38707 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaAROfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 09:35:14 -0500
Subject: [PATCH 0/2] Revert EISA init changes
To: linux-kernel@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Date: Sat, 18 Jan 2014 07:35:09 -0700
Message-ID: <20140118143308.32751.27410.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to make EISA device enumeration messages a bit nicer, but I
screwed up and caused some machines to hang during boot.

This was reported at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1251816

This reverts those changes.  I plan to include these in the PCI tree
for v3.14.

---

Bjorn Helgaas (2):
      Revert "EISA: Log device resources in dmesg"
      Revert "EISA: Initialize device before its resources"


 drivers/eisa/eisa-bus.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)
