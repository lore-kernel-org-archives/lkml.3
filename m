Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab3A1BSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 20:18:44 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55799 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab3A1BSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 20:18:41 -0500
Date: Sun, 27 Jan 2013 19:18:27 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: 3.7 HDMI channel map regression
Message-ID: <20130128011827.GA30485@lintop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

I recently updated my HTPC from 3.6.11 to 3.7.2 and this caused my RL
and FC channels to swap, and my RR and LFE channels to swap for PCM
audio.  Doing a git bisect identified
d45e6889ee69456a4d5b1bbb32252f460cd48fa9 "ALSA: hda - Provide the
proper channel mapping for generic HDMI driver" as the commit that
caused my channels to swap.  The commit doesn't revert cleanly on
3.7.4, and I haven't really looked to see what the correct fix might
be.

Some info that may be relevant, the sound card is a:

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)

The machine is running Fedora 18 and audio goes over HDMI to a 5.1
receiver.  I'm not really sure what other info you might need, but
let me know if you need something else or have any patches you would
like me to test.

Thanks,
Shawn
