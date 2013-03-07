Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab3CGOj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:39:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45853 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3CGOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:39:26 -0500
Date: Thu, 7 Mar 2013 15:39:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux@arm.linux.org.uk,
        arnd@arndb.de, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        torvalds@linux-foundation.org
Subject: Re: 3.9-rc1 regression in arm dtb build
Message-ID: <20130307143924.GA7344@amd.pavel.ucw.cz>
References: <20130306193332.GA6022@amd.pavel.ucw.cz>
 <20130306204557.3ff80000@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306204557.3ff80000@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-03-06 20:45:57, Thomas Petazzoni wrote:
> Dear Pavel Machek,
> 
> On Wed, 6 Mar 2013 20:33:32 +0100, Pavel Machek wrote:
> 
> > Moves dtb files from arch/arm/boot/ to arch/arm/boot/dtb. That causes
> > several problems:
> > 
> > 1) it is inconsistent with 3.8, making switching between 3.9-rc1 and
> > 3.8 tricky
> 
> The commit you're pointing to was part of 3.8, and so the dtb move to
> arch/arm/boot/dts/ is already here since quite a bit of time. At least,
> it's not something you introduced in 3.9-rc1.

Aha, so I guess it changed between 3.7 and 3.8... Anyway, perhaps it
is best to revert it now and treat it as a bug than having everyone
learn that 3.7- has it one way and 3.8+ different?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
