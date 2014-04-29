Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaD2Xza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:55:30 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35607 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaD2Xz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:55:27 -0400
Subject: [PATCH v2 0/2] x86/gart: message tidy-up
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 17:55:25 -0600
Message-ID: <20140429235015.11112.79459.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 of the patch I posted at [1].  I split this into two:

  1) Add pr_fmt() and convert to pr_info(), etc.
  2) Use more PCI-like device IDs, print ranges in %pR style, make more
     consistent.

Still no functional change except to messages.  I'd be glad to move
arch/x86/kernel/aperture_64.c to arch/x86/pci if desired; I didn't here
because it looks like several other files could also be moved, and I don't
know how far to go.

Bjorn

[1] http://lkml.kernel.org/r/20140425171655.312.97511.stgit@bhelgaas-glaptop.roam.corp.google.com

---

Bjorn Helgaas (2):
      x86/gart: Replace printk() with pr_info()
      x86/gart: Tidy messages and add bridge device info


 arch/x86/kernel/aperture_64.c |   59 ++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 28 deletions(-)
