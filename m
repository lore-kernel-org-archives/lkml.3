Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbaD2JkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:40:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51136 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaD2JkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:40:10 -0400
Date: Tue, 29 Apr 2014 11:40:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.15-rc3
Message-ID: <20140429094006.GA20064@xo-6d-61-c0.localdomain>
References: <CAJZ5v0gkQH0=hGTpA0fF=tpAW_t3eCvLkZPQ-=ROPmzzDYssLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0gkQH0=hGTpA0fF=tpAW_t3eCvLkZPQ-=ROPmzzDYssLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-04-26 02:11:51, Rafael J. Wysocki wrote:
> Hi Linus,
> 
> Please pull from
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
>  pm+acpi-3.15-rc3
> 
> to receive ACPI, power management and PNP fixes for v3.15-rc3
> with top-most commit d4c9c8a09cff85f69b2c224ca7dbeb42431da2b3

Actually... From 3.15-rc, I see occassional failure after resume.

Gnome2 dialog with "Do you want to suspend/hibernate/shutdown" stays on screen,
and with "suspend" button depressed. .. X session is no longer usable.

I can switch to console, nothing too suspicious in dmesg. ps shows
sh in "Zombie" state.

Does anyone else see that? (Desktop x86 machine with i915.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
