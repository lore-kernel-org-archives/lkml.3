Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3IVO0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:26:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56578 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3IVO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:26:31 -0400
Date: Sun, 22 Sep 2013 16:26:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com, rjw@sisk.pl,
        len.brown@intel.com, dtor@insightbb.com
Subject: Re: [PATCH 1/3] Input: atkbd - add LED triggers for keyboard state
Message-ID: <20130922142629.GA30282@amd.pavel.ucw.cz>
References: <1377180132-4933-1-git-send-email-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377180132-4933-1-git-send-email-Jason@zx2c4.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Many new laptop keyboards aren't shipping with LEDs in the keys for
> caps lock, num lock, and scroll lock. They do, however, ship with many LEDs
> for specialized functions that mostly go non-utilized by any current
> Linux drivers. Having a caps lock LED is very helpful in early boot full
> disk encryption, where a fancy GUI is not available to show that caps
> lock is activated.
> 
> This patch wires in the caps, num, and scroll lock states of the
> keyboard into the generic LED trigger subsystem, so that integrators can
> have different LEDs activated on caps/num/scroll lock state changes.

There's another patch floating around that properly integrates input
with LED subsystem; it already contains this functionality IIRC.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
