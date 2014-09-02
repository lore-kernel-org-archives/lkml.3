Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbaIBEFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 00:05:32 -0400
Received: from imap.thunk.org ([74.207.234.97]:60106 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaIBEFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 00:05:31 -0400
Date: Tue, 2 Sep 2014 00:05:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: [REGRESSION] i915: failure to see Dell 30" monitor connected to a
 Lenovo Haswell docking station
Message-ID: <20140902040527.GA5508@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently upgraded to v3.17-rc3, and on my Lenovo T540p, I can no
longer see the my Dell 30" monitor when it is connected via the
docking station using a Displayport connector.  This worked using 3.16
kernel.

If I connect to the monitor using the mini-display, by passing the
docking station, things work fine (but of course it's annoying not to
be able to use the docking station).

Is this a known problem?  This is not the first time that we've had
regressions with this docking station.   It's vaguely reminsicent of 

	https://bugs.freedesktop.org/show_bug.cgi?id=71267

Except the system isn't hanging; it's just not seeing the monitor at all.

Thanks,

					- Ted


