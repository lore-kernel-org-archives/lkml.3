Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaFJOSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:18:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25735 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaFJOSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:18:33 -0400
X-IronPort-AV: E=Sophos;i="4.98,1009,1392163200"; 
   d="scan'208";a="141617922"
Message-ID: <539713B2.1010506@citrix.com>
Date: Tue, 10 Jun 2014 15:18:26 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Grant Likely" <grant.likely@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Yinghai Lu" <yinghai@kernel.org>, <x86@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        "Tony Lindgren" <tony@atomide.com>
CC: Tony Luck <tony.luck@intel.com>, <linux-acpi@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-pci@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Xen-devel] [Patch V4 19/42] x86, irq: count legacy IRQs by legacy_pic->nr_legacy_irqs
 instead of NR_IRQS_LEGACY
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com> <1402302011-23642-20-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1402302011-23642-20-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/14 09:19, Jiang Liu wrote:
> Some platforms, such as Intel MID and mshypv, do not support legacy
> interrupt controllers. So count legacy IRQs by legacy_pic->nr_legacy_irqs
> instead of hard-coded NR_IRQS_LEGACY.
> 
[...]
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c

Xen bits:

Acked-by: David Vrabel <david.vrabel@citrix.com>

David
