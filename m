Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3KAOCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:02:31 -0400
Received: from 8bytes.org ([85.214.48.195]:38338 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab3KAOC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:02:28 -0400
Date: Fri, 1 Nov 2013 15:02:23 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Adam Williamson <awilliam@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Peter Anvin <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>,
        Robin Holt <holt@sgi.com>, davej@fedoraproject.org,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
Message-ID: <20131101140223.GJ17455@8bytes.org>
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
 <20131025105352.GA5419@gmail.com>
 <1382719652.2445.1.camel@adam.happyassassin.net>
 <CA+55aFyZEZp3CSFEcxzKt0c_7Q9_juGWiqb7VH214Fjcs3wUkQ@mail.gmail.com>
 <1382750841.19471.72.camel@adam.happyassassin.net>
 <1382754015.19471.80.camel@adam.happyassassin.net>
 <20131026031759.GA8513@redhat.com>
 <1382772154.3604.1.camel@adam.happyassassin.net>
 <20131026091501.GE14237@gmail.com>
 <1382857589.2447.0.camel@adam.happyassassin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382857589.2447.0.camel@adam.happyassassin.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Nov  1 15:02:27 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5273b47320865716378495
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 12:06:29AM -0700, Adam Williamson wrote:
> On Sat, 2013-10-26 at 11:15 +0200, Ingo Molnar wrote:
> >   CONFIG_IRQ_REMAP=y
> 
> Agh, sorry - I had this down in my mind as a boot time parameter, not a
> compile time option. I'm off on vacation for a week in the morning, and
> it's too late to wait around for a kernel compile tonight :/ So I'll
> have to check this one when I get back. Sorry again.

Note, instead of recompiling the kernel, you can also pass 'intremap=off'
on the kernel cmdline to disable interrupt remapping and test with that.


	Joerg


