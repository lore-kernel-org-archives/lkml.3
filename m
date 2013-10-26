Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3JZUAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:00:08 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:42680 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3JZUAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:00:05 -0400
MIME-Version: 1.0
In-Reply-To: <1382807301.3604.6.camel@adam.happyassassin.net>
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
	<20131025105352.GA5419@gmail.com>
	<1382719652.2445.1.camel@adam.happyassassin.net>
	<CA+55aFyZEZp3CSFEcxzKt0c_7Q9_juGWiqb7VH214Fjcs3wUkQ@mail.gmail.com>
	<1382750841.19471.72.camel@adam.happyassassin.net>
	<1382754015.19471.80.camel@adam.happyassassin.net>
	<20131026031759.GA8513@redhat.com>
	<1382772154.3604.1.camel@adam.happyassassin.net>
	<20131026091501.GE14237@gmail.com>
	<1382807301.3604.6.camel@adam.happyassassin.net>
Date: Sat, 26 Oct 2013 13:00:03 -0700
X-Google-Sender-Auth: gKgBWddX23zPwCrX2bF3MxWB_p8
Message-ID: <CA+55aFxwLuw=OTtn_u5Tk00xXbuSe6GAiTJ=UiySkr4E2CBAGw@mail.gmail.com>
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci" default
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adam Williamson <awilliam@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Dave Jones <davej@redhat.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Peter Anvin <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, Robin Holt <holt@sgi.com>,
        davej@fedoraproject.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 10:08 AM, Adam Williamson <awilliam@redhat.com> wrote:
>
> Thanks, I'll give it a shot. Note - I suspect some of the other cases
> may really be delays rather than hangs too. It's very easy to look at
> the screen sitting there doing absolutely nothing at all for 30-60
> seconds, lose patience, conclude it's hung, and force a shutdown/reboot.
> Several of the earlier Z1 reporters on the vaio-z mailing list reported
> it as a 'hang', but after I pointed out that it wasn't, confirmed the
> same behaviour on their systems. This could possibly apply to others
> too.

I agree that a delay of 60s may well be reported as a hang, but at
least for the Dell case I can test, the hang is definitely at least
close to infinite. Definitely longer than a couple of minutes.

So the Sony and Dell issues may be different. That said, vt-d was
suspected for both, and apparently does match your kernel versions, so
it's entirely possible that the fundamental cause is the same even if
the symptoms are slightly different.

                    Linus
