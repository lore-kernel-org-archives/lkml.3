Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3GOJ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:27:30 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54051 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3GOJ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:27:29 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        akpm@linux-foundation.org, jslaby@suse.cz, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>
Subject: Re: [PATCH] Route kbd LEDs through the generic LEDs layer
References: <201011112205.oABM5KVJ005298@imap1.linux-foundation.org>
	<201011111440.07882.dmitry.torokhov@gmail.com>
	<20110102090935.GV32469@atrey.karlin.mff.cuni.cz>
	<20110102103210.GA25662@core.coreip.homeip.net>
	<20110102225741.GX5480@const.famille.thibault.fr>
	<20110112182702.GA9168@core.coreip.homeip.net>
	<20111114040613.GA4992@type.famille.thibault.fr>
	<20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
	<20130707101028.GD5651@type.youpi.perso.aquilenet.fr>
Date: Mon, 15 Jul 2013 11:27:24 +0200
In-Reply-To: <20130707101028.GD5651@type.youpi.perso.aquilenet.fr> (Samuel
	Thibault's message of "Sun, 7 Jul 2013 12:10:28 +0200")
Message-ID: <87wqos9nr7.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Samuel" == Samuel Thibault <samuel.thibault@ens-lyon.org> writes:

 Samuel> This permits to reassign keyboard LEDs to something else than keyboard "leds"
 Samuel> state, by adding keyboard led and modifier triggers connected to a series
 Samuel> of VT input LEDs, themselves connected to VT input triggers, which
 Samuel> per-input device LEDs use by default.  Userland can thus easily change the LED
 Samuel> behavior of (a priori) all input devices, or of particular input devices.

 Samuel> This also permits to fix #7063 from userland by using a modifier to implement
 Samuel> proper CapsLock behavior and have the keyboard caps lock led show that modifier
 Samuel> state.

 Samuel> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
 Samuel> [ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
 Samuel> Signed-off-by: Evan Broder <evan@ebroder.net>

Looks good to me. Samuel, thanks for picking this up again.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
