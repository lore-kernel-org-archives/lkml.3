Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaHGLDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:03:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60777 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbaHGLDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:03:37 -0400
Date: Thu, 7 Aug 2014 13:03:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Subject: tip/x86/apic (was: Re: [Bugfix 1/2] x86, irq, PCI: Keep IRQ
 assignment for PCI devices during suspend/hibernation)
Message-ID: <20140807110332.GB10043@pd.tnic>
References: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com>
 <1407209178-18644-2-git-send-email-jiang.liu@linux.intel.com>
 <20140805183729.GA23068@pd.tnic>
 <53E201FC.6010102@linux.intel.com>
 <20140806170937.GA4895@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140806170937.GA4895@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 07:09:37PM +0200, Borislav Petkov wrote:
> On Wed, Aug 06, 2014 at 06:22:52PM +0800, Jiang Liu wrote:
> > 	I have prepared a tree for you at
> > https://github.com/jiangliu/linux.git suspend2
> > 
> > It's based on tip/master and includes:
> > 1) the patch to fix warning caused  by USB controller
> > 2) these two patches to fix failure of suspend/hibernation
> > 
> > Could you please help to check whether suspend/hibernation works as
> > expect on your platforms?
> 
> Seems to work - just did 10-ish successful s/r cycles. The IO page
> faults are still there though.

Ok, tip guys, so Jörg and I talked about the IOPFs a bit and we feel
that while they still need to be taken care of, they're harmless and
there's no need to hold off tip/x86/apic anymore unless there are other
problems with it.

So, from my POV, it can go in so that it doesn't miss this merge window
and we'd deal with the IOPFs later.

I'm guessing Jiang needs to give you some updated versions of patches
from this thread for the branch to be complete. Jiang, please add my

Tested-by: Borislav Petkov <bp@suse.de>

for those.

Thanks to everyone involved.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
