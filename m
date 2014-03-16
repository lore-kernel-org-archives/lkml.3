Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaCPK1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 06:27:09 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:58566 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaCPK1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 06:27:07 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2014 06:27:07 EDT
Date: Sun, 16 Mar 2014 11:19:46 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Richard Purdie <rpurdie@rpsys.net>,
        LKML <linux-kernel@vger.kernel.org>, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH] Route kbd LEDs through the generic LEDs layer
Message-ID: <20140316101946.GJ6436@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
	Richard Purdie <rpurdie@rpsys.net>,
	LKML <linux-kernel@vger.kernel.org>, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>
References: <20110102103210.GA25662@core.coreip.homeip.net>
 <20110102225741.GX5480@const.famille.thibault.fr>
 <20110112182702.GA9168@core.coreip.homeip.net>
 <20111114040613.GA4992@type.famille.thibault.fr>
 <20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
 <20130713093552.GU8252@type>
 <20130715091230.GA8786@amd.pavel.ucw.cz>
 <CAHYPw2H94ej=FdqHAxXpyZt+34TwK1Qj7LWP_bMro-v3JREisg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHYPw2H94ej=FdqHAxXpyZt+34TwK1Qj7LWP_bMro-v3JREisg@mail.gmail.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pali Rohár, le Sun 16 Mar 2014 11:16:25 +0100, a écrit :
> Hello, what happened with this patch? Is there any problem with accepting it?

Dmitry finding time to review it, I guess.

Samuel
