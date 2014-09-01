Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaIAUTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 16:19:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46738 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751458AbaIAUTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 16:19:24 -0400
Date: Mon, 1 Sep 2014 16:19:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Daniel Vetter <daniel@ffwll.ch>
cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Regression in drm-intel caused by d91a2cb8e510
Message-ID: <Pine.LNX.4.44L0.1409011609390.13894-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel:

I'm encountering a problem with the drm-intel-nightly branch in your
drm-intel repository.  The symptom is that when I boot my laptop, at
some point during the start-up procedure the screen goes totally blank,
as though the backlight were turned off, and it remains that way.  I
can't tell if the backlight really is off -- it may be that there's
just nothing being displayed -- and playing with the screen-brightness
function keys doesn't help.

Git bisect located the source of the problem as commit d91a2cb8e510
(drm/i915: Add 180 degree primary plane rotation support).  The problem
occurs when I boot a kernel built from that commit, and it doesn't
occur when I boot a kernel built from the preceding commit
(19ac737dc3c3).

If necessary, I can get debugging info by logging in over a network 
connection.  Tell me what you need.

Alan Stern

