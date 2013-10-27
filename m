Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3J0HGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 03:06:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3J0HGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 03:06:47 -0400
Message-ID: <1382857589.2447.0.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
From: Adam Williamson <awilliam@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>,
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
Date: Sun, 27 Oct 2013 00:06:29 -0700
In-Reply-To: <20131026091501.GE14237@gmail.com>
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
	 <20131025105352.GA5419@gmail.com>
	 <1382719652.2445.1.camel@adam.happyassassin.net>
	 <CA+55aFyZEZp3CSFEcxzKt0c_7Q9_juGWiqb7VH214Fjcs3wUkQ@mail.gmail.com>
	 <1382750841.19471.72.camel@adam.happyassassin.net>
	 <1382754015.19471.80.camel@adam.happyassassin.net>
	 <20131026031759.GA8513@redhat.com>
	 <1382772154.3604.1.camel@adam.happyassassin.net>
	 <20131026091501.GE14237@gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-26 at 11:15 +0200, Ingo Molnar wrote:

> So if you are able to test current kernels, it might be an 
> additional data point to see whether the reboot delay (which appears 
> to be a reboot hang on other systems) is related to the following 
> kernel option:
> 
>   CONFIG_IRQ_REMAP=y

Agh, sorry - I had this down in my mind as a boot time parameter, not a
compile time option. I'm off on vacation for a week in the morning, and
it's too late to wait around for a kernel compile tonight :/ So I'll
have to check this one when I get back. Sorry again.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

