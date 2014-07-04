Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaGDKfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:35:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58493 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaGDKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:35:09 -0400
Date: Fri, 4 Jul 2014 12:35:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Udo Seidel <udoseidel@gmx.de>
Subject: Re: [PATCH -repost 05/21] kgr: update Kconfig documentation
Message-ID: <20140704103505.GB19252@amd.pavel.ucw.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
 <1403694435-3180-5-git-send-email-jslaby@suse.cz>
 <20140625134212.4fb38e14@alan.etchedpixels.co.uk>
 <53ABD8FB.9000700@suse.cz>
 <alpine.LNX.2.00.1406261030210.15939@pobox.suse.cz>
 <20140627191845.GA1408@xo-6d-61-c0.localdomain>
 <53B6708E.5030106@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B6708E.5030106@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-07-04 11:14:54, Jiri Slaby wrote:
> On 06/27/2014 09:18 PM, Pavel Machek wrote:
> >>> This now writes:
> >>> +       help
> >>> +         Select this to enable kGraft online kernel patching. The
> >>> +         runtime price is nearly zero, so it is safe to say Y here
> >>> +         provided you are aware of all the consequences (e.g. in
> >>> +         security).
> >>>
> >>> Is it OK with you?
> >>
> >> This might cause a false impression that we are actually opening a 
> >> security hole into a system, which is not true at all.
> >>
> >> Yes, backdoor writeres might (or might not) make use of kGraft API, but 
> >> they have gazillion of other comparable options (*probes, ftrace, 
> >> text_poke(), ...).
> >>
> >> I'd perhaps propose something like
> >>
> >> "Select this to enable kGraft live kernel patching. The runtime penalty is 
> >> nearly zero, so it is safe to say Y here if you want the kernel to expose 
> >> API for live patching to modules".

It is "safe" but completely stupid to say Y here, unless you are a
distro vendor.

> > Well. People that are not distro vendors will not prepare patches for
> > themselves, right?
> 
> Hi, why do you believe so? But it is not so important, see below.

Because it is quite hard to prepare the patch, and there's not really
enough documentation..? And given choice between "spend half an hour
preparing patch" and "just reboot", people compiling their own kernels
know what to do...

> > And patches prepared for suse will not work on
> > self-configured kernels.
> > 
> > So probably everyone should say "N" here...
> 
> The text is formulated correctly and satisfies your concerns, I think.
> Say Y, if you want the API...

Lawyer may read it correctly. For the rest of human beings, it should
say "say N here". Three people in the world that can prepare the patch
know they need the option  enabled, even without help text.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
