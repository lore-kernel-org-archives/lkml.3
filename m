Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3JMQXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:23:46 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:43947 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3JMQXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:23:44 -0400
Date: Sun, 13 Oct 2013 18:23:31 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>
Subject: Re: [PATCHv2] Route kbd LEDs through the generic LEDs layer
Message-ID: <20131013162331.GU14778@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
	Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org,
	Steev Klimaszewski <steev@genesi-usa.com>
References: <20130717152916.GI5883@type.bordeaux.inria.fr>
 <20130904172621.GA5957@type.bordeaux.inria.fr>
 <20131008160152.a98961b9e54bf1c45c1818dc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131008160152.a98961b9e54bf1c45c1818dc@linux-foundation.org>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton, le Tue 08 Oct 2013 16:01:52 -0700, a écrit :
> Do you believe that the earlier controversies are now addressed and if
> so, how?

Yes.  Dmitry thought more about how to integrate that nicely on 12th
Jan 2011, which I did.  The patch was rebased on 3.x, and I submitted a
reworked patch on 21st Dec 2012. David Herrmann did a code review, which
were answered by small changes.

> Have the earlier participants in that discussion been cc'ed
> and have they commented?

I believe they have all been cc'ed.  They have not provided more
comments.

> In other words, how are we generally getting along with those things?  

I believe this is ready, just Dmitry didn't have time to process it yet.

> The one-line change to drivers/tty/vt/keyboard.c no longer applies -
> LED_SHOW_MEM has vanished altogether.

Good thing :)

Thanks,
Samuel
