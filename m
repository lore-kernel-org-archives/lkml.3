Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3JZHWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 03:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3JZHWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 03:22:49 -0400
Message-ID: <1382772154.3604.1.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
From: Adam Williamson <awilliam@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Lan Tianyu <tianyu.lan@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Peter Anvin <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, Robin Holt <holt@sgi.com>,
        davej@fedoraproject.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 26 Oct 2013 00:22:34 -0700
In-Reply-To: <20131026031759.GA8513@redhat.com>
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
	 <20131025105352.GA5419@gmail.com>
	 <1382719652.2445.1.camel@adam.happyassassin.net>
	 <CA+55aFyZEZp3CSFEcxzKt0c_7Q9_juGWiqb7VH214Fjcs3wUkQ@mail.gmail.com>
	 <1382750841.19471.72.camel@adam.happyassassin.net>
	 <1382754015.19471.80.camel@adam.happyassassin.net>
	 <20131026031759.GA8513@redhat.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 23:17 -0400, Dave Jones wrote:
> On Fri, Oct 25, 2013 at 07:20:15PM -0700, Adam Williamson wrote:
>  > OK, so, findings: F16 and F17 live images reboot quickly. F18 is the
>  > first that reboots slowly.
> 
> wait, stop. what does "reboots slowly" mean ? 
> In every one of the failure I've seen, without a quirk it means reboot
> doesn't happen at all.

If you read the original report - on Z1s, if you leave the system alone,
it sits at the 'Restarting system.' message for about two minutes, then
finally reboots. If you pass 'reboot=pci', reboot is as fast as you'd
expect.

https://bugzilla.kernel.org/show_bug.cgi?id=61721
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

