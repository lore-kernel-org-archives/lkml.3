Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaHIRGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:06:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59333 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbaHIRGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:06:51 -0400
Date: Sat, 9 Aug 2014 19:06:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
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
        linux-acpi@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] x86/apic changes for v3.17
Message-ID: <20140809170643.GC4209@pd.tnic>
References: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com>
 <1407209178-18644-2-git-send-email-jiang.liu@linux.intel.com>
 <20140805183729.GA23068@pd.tnic>
 <53E201FC.6010102@linux.intel.com>
 <20140806170937.GA4895@pd.tnic>
 <20140807110332.GB10043@pd.tnic>
 <20140807113346.GA24225@gmail.com>
 <alpine.DEB.2.02.1408081519240.7430@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408081519240.7430@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 03:21:44PM -0700, David Rientjes wrote:
> On Thu, 7 Aug 2014, Ingo Molnar wrote:
> 
> > Linus, please pull the latest x86-apic-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus
> > 
> >    # HEAD: 5e3bf215f4f2efc0af89e6dbc5da789744aeb5d7 x86/apic/vsmp: Make is_vsmp_box() static
> > 
> > 
> > The main changes in this cycle are:
> > 
> >     * Remove obsolete APIC driver abstractions. (David Rientjes)
> > 
> 
> These changes are unrelated from the other issues and can still be pulled 
> from
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git x86/apic 
> 
> if we want the cleanups for 3.17.  The x86 pull request was originally at 
> http://marc.info/?l=linux-kernel&m=140678961924050.
> 
> It would be a shame to miss out on that because the changes share the same 
> tip branch.

Actually, that whole branch could go in now, especially since Thomas
picked up the stable IRQ numbers assignment during s/r fix:

https://lkml.kernel.org/r/tip-3eec595235c17a74094daa1e02d1b0af2e9a7125@git.kernel.org

@tglx: I don't know about IOAPIC reference count:

https://lkml.kernel.org/r/1407209178-18644-3-git-send-email-jiang.liu@linux.intel.com

This looks like a bugfix too.

With those two applied, tip/x86/apic is good to go IMHO. The only thing
that remains are the IOMMU IOPFs which we'll deal accordingly later -
they need shutting up only anyway.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
