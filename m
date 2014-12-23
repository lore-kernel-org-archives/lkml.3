Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaLWH5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:57:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:62742 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbaLWH5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:57:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="503012438"
Message-ID: <5499204B.4040808@linux.intel.com>
Date: Tue, 23 Dec 2014 15:56:59 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tudor Laurentiu <b10716@freescale.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Scott Wood <scottwood@freescale.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Ask help about killing irqchip.irq_print_chip on PPC platforms
References: <54991DE5.5090805@linux.intel.com>
In-Reply-To: <54991DE5.5090805@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott and Tudor,
	Sorry, resend and Ccing the list.
	We are trying to clean up some irqchip interfaces, and
irqchip.irq_print_chip is a candidate for removal. After some
changes on x86 side, arch/powerpc/sysdev/fsl_msi.c may be the
last user of irqchip.irq_print_chip. So could you please help
to advice on whether we could kill irqchip.irq_print_chip
by using "fsl-msi" instead of "fsl-msi-%d" for irqchip name?
Will it break any userspace interfaces?
Thanks!
Gerry
