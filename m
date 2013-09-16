Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3IPAGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 20:06:14 -0400
Received: from imap.thunk.org ([74.207.234.97]:60704 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab3IPAGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 20:06:12 -0400
Date: Sun, 15 Sep 2013 20:06:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Marcus Sundman <marcus@hibox.fi>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130916000603.GA7695@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Marcus Sundman <marcus@hibox.fi>, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
References: <20130226231703.GA22674@quack.suse.cz>
 <5231BA3C.2090704@hibox.fi>
 <20130912131051.GA14664@quack.suse.cz>
 <5231C5FF.3060504@hibox.fi>
 <20130912143941.GB14664@quack.suse.cz>
 <5231D8DD.5010703@hibox.fi>
 <20130912163530.GD14664@quack.suse.cz>
 <523200EB.7000202@hibox.fi>
 <20130914024108.GA10740@thunk.org>
 <5236084D.3060509@hibox.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5236084D.3060509@hibox.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 10:19:41PM +0300, Marcus Sundman wrote:
> 
> It's a SanDisk SSD U100.

Here's one report of someone who had an experience with U100 in an
Asus UX31E:

https://communities.intel.com/thread/32515

> A lot. I have lsyncd running here most of the time, backing up to my
> raid-z NAS which in turn uses a versioned off-site backup system.
> Anyway, this is an Asus ZenBook computer and can't be opened. Well,
> it can, but that will void the warranty at the very least.

Personally, I avoid like the plague laptop computers where I can't
replace the storage devices (or upgrade memory, etc.) without voiding
the warrantee....

I generally order laptops without the flash device, and carefully
select for high quality flash devices.  Otherwise, you end up paying
too much for what is generally shoddy equipment....

					- Ted
