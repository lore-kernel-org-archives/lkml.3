Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab3KRXno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:43:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab3KRXnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:43:41 -0500
Message-ID: <1384818204.2584.2.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
From: Adam Williamson <awilliam@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
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
Date: Mon, 18 Nov 2013 15:43:24 -0800
In-Reply-To: <20131101140223.GJ17455@8bytes.org>
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
	 <20131101140223.GJ17455@8bytes.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 15:02 +0100, Joerg Roedel wrote:
> On Sun, Oct 27, 2013 at 12:06:29AM -0700, Adam Williamson wrote:
> > On Sat, 2013-10-26 at 11:15 +0200, Ingo Molnar wrote:
> > >   CONFIG_IRQ_REMAP=y
> > 
> > Agh, sorry - I had this down in my mind as a boot time parameter, not a
> > compile time option. I'm off on vacation for a week in the morning, and
> > it's too late to wait around for a kernel compile tonight :/ So I'll
> > have to check this one when I get back. Sorry again.
> 
> Note, instead of recompiling the kernel, you can also pass 'intremap=off'
> on the kernel cmdline to disable interrupt remapping and test with that.

Sorry for the delay, folks - just got back to this. Booting with
'intremap=off' results in a slow reboot, i.e., doesn't fix the bug. Is
that a sufficient test, Ingo, or do you still want me to build with
CONFIG_IRQ_REMAP=n and try that?
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

