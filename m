Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3JIVCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:02:24 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55128 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3JIVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:02:22 -0400
Subject: [PATCH] MAINTAINERS: Add arch/x86/pci to PCI file patterns
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Oct 2013 15:02:20 -0600
Message-ID: <20131009210219.31110.62076.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I handle many arch/x86/pci changes, so help those patches get to the
PCI patchwork.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..d1ab647 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6338,6 +6338,7 @@ S:	Supported
 F:	Documentation/PCI/
 F:	drivers/pci/
 F:	include/linux/pci*
+F:	arch/x86/pci/*
 
 PCI DRIVER FOR NVIDIA TEGRA
 M:	Thierry Reding <thierry.reding@gmail.com>

