Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3JHVN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:13:56 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:50903 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756531Ab3JHVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:13:54 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 17:13:54 EDT
Date: Tue, 8 Oct 2013 16:07:12 -0500
From: lkml@pengaru.com
To: linux-kernel@vger.kernel.org
Subject: snd_hda_intel headphone output disabling upon complete insertion of plug
Message-ID: <20131008210712.GC16883@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

Somewhere between 3.11.0-rc7-gfa8218d and 3.12.0-rc4-g8b5ede6 this
broke.

The machine is an x61s thinkpad, with the headphone output unmuted and
headphones partially inserted sound is audible.  If the output is muted,
the output shuts off.  With the output unmuted, upon inserting the
headphone plug fully the output shuts off following a blink of a delay.
If I slowly remove the headphone plug returning it to a partially inserted
state, the audio returns after another delay.

It seems like a bug in the headphone amplifier power management, as if
it's doing the inverse of what it needs to do.  I'll try find time to
bisect, just wanted to get this out there though in case any of you
recognize the problem and know what might have caused it.

Regards,
Vito Caputo
