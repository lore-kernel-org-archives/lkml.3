Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaFRQO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:14:59 -0400
Received: from imap.thunk.org ([74.207.234.97]:45871 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaFRQO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:14:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Display glitching (and possibly related lockup) in 3.16-rc1?
Date: Wed, 18 Jun 2014 12:14:55 -0400
Message-ID: <nsxppi6tcsg.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this a known problem?

On my T540p, occasionally the display will go black and then be
completely locked.  One time when this happened, the display started
glitching and tearing (like what you might see if an analog display had
a loose connector and it was being wiggled) when the system locked up,
but the at least 75% of the time when the bug manifests, the screen goes
black instead.

This appears to only happen when the system is running on battery --- it
doesn't seem to manifest if I'm plugged into the AC mains.  And I've
been typing an e-mail message when the system locks up, so I don't think
it's related to DPMS or the screen saver kicking in.

I can try to bisect this regression (3.15 didn't have this problem), but
I thought I would ask first if this was a known problem.   I don't know
for certain that it's an i915 bug, but the symptoms do somewhat point in
that direction, especially the display glitches.

Thanks!!

                                        - Ted
