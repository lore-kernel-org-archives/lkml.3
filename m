Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaDKGOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:14:04 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:55487 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaDKGOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:14:00 -0400
Date: Fri, 11 Apr 2014 08:12:02 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
        jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] Route keyboard LEDs through the generic LEDs layer.
Message-ID: <20140411061202.GA8321@type>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
	akpm@linux-foundation.org, jslaby@suse.cz,
	Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org,
	Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
References: <20140331122323.GC6044@type.bordeaux.inria.fr>
 <20140407021015.GA8518@core.coreip.homeip.net>
 <20140407075423.GZ7179@type.wlan.youpi.perso.aquilenet.fr>
 <20140408083940.GA22855@core.coreip.homeip.net>
 <20140408233306.GJ27820@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140408233306.GJ27820@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm sorry this went out with a few mistakes.

Samuel Thibault, le Wed 09 Apr 2014 01:33:06 +0200, a écrit :
> Dmitry Torokhov, le Tue 08 Apr 2014 01:39:40 -0700, a écrit :
> > It is not about the VT, I am talking about pure input core. If I
> > repurpose CapsLock LED for my WiFi indicator I do not want to go into
> > other programs and teach them that they should stay away from trying to
> > control this LED.
> 
> Err, but even without talking about repurposing Capslock LED for WiFi...
> How is managed the conflict between the normal capslock behavior and
> other programs' action on the underlying input device?  I don't think
> this patch does not introduce the problem.

I of course meant "I don't think this patch introduces the problem".

> How to decide which one to prioritize?
> 
> Is it just because console-setup happens to repurpose the capslock LED
> key that applications should suddenly not have capslock LED control
> at all?  That's contradictory with the use case you have given.

Oops, not the use case you have given, but a typical use-case of wanting
to use a program which does nice things with the capslock LED, and then
having to teach console-setup not to repurpose the capslock LED.

> That
> leads me into believing that we should not try to push a hard rule, and
> just let the user manage what accesses it.  We could indeed make the VT
> always take priority, but then that would probably break some existing
> applications.

Such as the example above, with the capslock LED.

Samuel
