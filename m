Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaKZXR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:17:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaKZXR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:17:57 -0500
Date: Wed, 26 Nov 2014 15:17:06 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-c36733f66f522a73cfb1a74e00f25eac841da5f4@git.kernel.org>
Cc: jroedel@suse.de, tglx@linutronix.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, tony.luck@intel.com,
        rjw@rjwysocki.net, mingo@kernel.org, joro@8bytes.org, hpa@zytor.com,
        konrad.wilk@oracle.com, wangyijing@huawei.com,
        jiang.liu@linux.intel.com, bp@alien8.de, benh@kernel.crashing.org,
        yinghai@kernel.org, rdunlap@infradead.org
Reply-To: rdunlap@infradead.org, yinghai@kernel.org, benh@kernel.crashing.org,
        bp@alien8.de, jiang.liu@linux.intel.com, wangyijing@huawei.com,
        konrad.wilk@oracle.com, hpa@zytor.com, joro@8bytes.org,
        mingo@kernel.org, rjw@rjwysocki.net, tony.luck@intel.com,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, jroedel@suse.de
In-Reply-To: <1416901802-24211-18-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-18-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86:
  Clean up unused forward declarations in x86_init.h
Git-Commit-ID: c36733f66f522a73cfb1a74e00f25eac841da5f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c36733f66f522a73cfb1a74e00f25eac841da5f4
Gitweb:     http://git.kernel.org/tip/c36733f66f522a73cfb1a74e00f25eac841da5f4
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:41 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:47 +0100

x86: Clean up unused forward declarations in x86_init.h

Clean up unused forward declarations in x86_init.h.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Yijing Wang <wangyijing@huawei.com>
Link: http://lkml.kernel.org/r/1416901802-24211-18-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/x86_init.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 4ada3d3..09d4dab 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -171,7 +171,6 @@ struct x86_platform_ops {
 };
 
 struct pci_dev;
-struct msi_msg;
 
 struct x86_msi_ops {
 	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
@@ -180,11 +179,6 @@ struct x86_msi_ops {
 	void (*restore_msi_irqs)(struct pci_dev *dev);
 };
 
-struct IO_APIC_route_entry;
-struct io_apic_irq_attr;
-struct irq_data;
-struct cpumask;
-
 struct x86_io_apic_ops {
 	void		(*init)   (void);
 	unsigned int	(*read)   (unsigned int apic, unsigned int reg);
