Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbaHFRJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:09:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48902 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbaHFRJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:09:41 -0400
Date: Wed, 6 Aug 2014 19:09:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Bugfix 1/2] x86, irq, PCI: Keep IRQ assignment for PCI devices
 during suspend/hibernation
Message-ID: <20140806170937.GA4895@pd.tnic>
References: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com>
 <1407209178-18644-2-git-send-email-jiang.liu@linux.intel.com>
 <20140805183729.GA23068@pd.tnic>
 <53E201FC.6010102@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53E201FC.6010102@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 06:22:52PM +0800, Jiang Liu wrote:
> 	I have prepared a tree for you at
> https://github.com/jiangliu/linux.git suspend2
> 
> It's based on tip/master and includes:
> 1) the patch to fix warning caused  by USB controller
> 2) these two patches to fix failure of suspend/hibernation
> 
> Could you please help to check whether suspend/hibernation works as
> expect on your platforms?

Seems to work - just did 10-ish successful s/r cycles. The IO page
faults are still there though.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
