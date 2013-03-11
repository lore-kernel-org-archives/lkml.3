Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3CKInA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:43:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:3600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab3CKIm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:42:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="303700747"
Subject: [PATCH 0/3] genirq: Do not consider the irqs with disabling and
 IRQF_NO_SUSPEND
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Mar 2013 01:53:16 +0800
Message-ID: <1363024396.31506.60.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Meet some issues when operating one ioapic chip irq which
is set with _NO_SUSPEND flag and calling irq_set_irq_wake().

Written the below patches, thanks your time to review.

[PATCH 1/3] x86, io_apic: Adding the flag IRQCHIP_SKIP_SET_WAKE
[PATCH 2/3] genirq: Do not consider the irqs with disabling and IRQF_NO_SUSPEND
[PATCH 3/3] genirq: Give warning in case calling irq_set_irq_wake with _NO_SUSPEND flag


