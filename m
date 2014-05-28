Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaE1UuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:50:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:40310 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaE1UuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:50:08 -0400
Date: Wed, 28 May 2014 22:49:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC Patch V1 1/4] x86, irq: refine mp_register_ioapic() to
 prepare for IOAPIC hotplug
In-Reply-To: <1401179077-2020-2-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1405282247530.3952@nanos>
References: <1401179077-2020-1-git-send-email-jiang.liu@linux.intel.com> <1401179077-2020-2-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Jiang Liu wrote:

> -static void ioapic_create_irqdomains(void)
> +static int ioapic_create_irqdomain(int idx)

...

> -static int __init io_apic_get_redir_entries(int ioapic)
> +static int io_apic_get_redir_entries(int ioapic)

Can you please split the functional changes from the trivial __init
removal ones?

Thanks,

	tglx
