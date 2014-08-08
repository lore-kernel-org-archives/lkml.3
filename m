Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaHHIJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:09:33 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37061 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaHHIJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:09:24 -0400
Date: Fri, 8 Aug 2014 10:09:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        the arch/x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] x86/apic changes for v3.17
Message-ID: <20140808080918.GB8502@gmail.com>
References: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com>
 <1407209178-18644-2-git-send-email-jiang.liu@linux.intel.com>
 <20140805183729.GA23068@pd.tnic>
 <53E201FC.6010102@linux.intel.com>
 <20140806170937.GA4895@pd.tnic>
 <20140807110332.GB10043@pd.tnic>
 <20140807113346.GA24225@gmail.com>
 <20140807133148.GC10043@pd.tnic>
 <CA+55aFzWZSc4vK5qK9jrjE1hfRSxdcWxmPHe7mfYWQtjY7WiSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzWZSc4vK5qK9jrjE1hfRSxdcWxmPHe7mfYWQtjY7WiSQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Aug 7, 2014 at 3:31 AM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > This tree still needs the suspend/resume fixes on this thread AFAICT.
> > Like keeping IRQ numbers of PCI devices stable across a s/r cycle, for
> > example.
> >
> > I'm guessing you'll send Linus a follow-up pull request with those
> > later, right?
> 
> If there are known issues with suspend/resume, I'm not willing to 
> pull this yet. The code for the merge window is supposed to be 
> complete and ready.
> 
> Ingo?

Yeah, I think it might be better to delay this for v3.18 after all and 
let it cook - I should not have tried to hurry and force it, my bad, 
sorry about that!

Thanks,

	Ingo
