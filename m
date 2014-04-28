Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaD1Xqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:46:37 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49185 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaD1Xqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:46:36 -0400
Subject: [PATCH] MAINTAINERS: Add arch/x86/kernel/quirks.c to PCI file
 patterns
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Apr 2014 17:46:33 -0600
Message-ID: <20140428234632.30583.25027.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not asserting any claim over arch/x86/kernel/quirks.c, and I don't plan
to merge changes to it, but some of the quirks there are PCI-related, and
I'd like to see changes to them.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1fdb50..8dbea21d973d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6693,6 +6693,7 @@ F:	Documentation/PCI/
 F:	drivers/pci/
 F:	include/linux/pci*
 F:	arch/x86/pci/
+F:	arch/x86/kernel/quirks.c
 
 PCI DRIVER FOR IMX6
 M:	Richard Zhu <r65037@freescale.com>

