Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaGFMfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 08:35:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47685 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGFMfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 08:35:08 -0400
Date: Sun, 6 Jul 2014 14:35:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Udo Seidel <udoseidel@gmx.de>
Subject: Re: [PATCH -repost 05/21] kgr: update Kconfig documentation
Message-ID: <20140706123506.GA18204@amd.pavel.ucw.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
 <1403694435-3180-5-git-send-email-jslaby@suse.cz>
 <20140625134212.4fb38e14@alan.etchedpixels.co.uk>
 <53ABD8FB.9000700@suse.cz>
 <alpine.LNX.2.00.1406261030210.15939@pobox.suse.cz>
 <20140627191845.GA1408@xo-6d-61-c0.localdomain>
 <53B6708E.5030106@suse.cz>
 <20140704103505.GB19252@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1407052146280.1655@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407052146280.1655@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-07-05 21:47:45, Jiri Kosina wrote:
> On Fri, 4 Jul 2014, Pavel Machek wrote:
> 
> > > Hi, why do you believe so? But it is not so important, see below.
> > 
> > Because it is quite hard to prepare the patch, and there's not really
> > enough documentation..? And given choice between "spend half an hour
> > preparing patch" and "just reboot", people compiling their own kernels
> > know what to do...
> 
> I fail to see how "having the skills to compile my own kernel" and "being 
> responsible for a datacenter that can't afford immediate reboot of all 
> nodes" are connected in any way.

Parse error, or too much irony.

Anyway, I'd suggest the Kconfig test be something like "say N unless
you know how to prepare patch for running kernel, and plan to do
that".

And, since you seem to be targeting sysadmins with this, it would be
cool to have sysadmin-targeted documentation explaining what patches
are safe to apply with kgraft and what are not.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
