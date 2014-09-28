Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaI1MrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 08:47:13 -0400
Received: from imap.thunk.org ([74.207.234.97]:53292 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbaI1MrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 08:47:11 -0400
Date: Sun, 28 Sep 2014 08:46:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: ext4: 3.17? problems
Message-ID: <20140928124658.GB6694@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
References: <20140928104456.GA17400@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928104456.GA17400@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 12:44:56PM +0200, Pavel Machek wrote:
> 
> After update to debian testing, my machine sometimes fails to
> reboot. (aptitude upgrade seems to be the trigger).
> 
> So I had to hard power-down the machine. That should be perfectly
> safe, as ext4 has a journal, and this is plain SATA disk, right?
> 
> On next boot to Debian stable, I got stacktrace, and messages about
> ext4 corruption. Back to Debian testing. systemd ran fsck, determined
> it can't fix it, dropped me into emergency shell, _but mounted the
> filesstem, anyway_. Oops.

I've been running 3.17-rc4 plus the ext4 dev patches and due to either
regressions in i915 or the X server (not sure which) over the last
couple of weeks, I've had to power-down my system a number of times
after the system has hung when either shutting down the X server or
when trying to add or remove an external display.  So I've had to
unfortunately do a fair number of hard-power-offs on my T540p, and
I've not noticed any like what you've described.

Can you give any more details?  Are you using LVM or dm-crypt?  Is
this repeatable?

Cheers,

							- Ted
