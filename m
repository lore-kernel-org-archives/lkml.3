Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbbABTxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 14:53:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34418 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbbABTxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 14:53:53 -0500
Date: Fri, 2 Jan 2015 20:53:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv5 0/2] INPUT: Route keyboard LEDs through the generic
 LEDs layer
Message-ID: <20150102195350.GB27538@amd>
References: <20141226232116.GA5069@type>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141226232116.GA5069@type>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Here is v5 coming, with separate patches for the kbd and the input
> parts.

After booting with this, capslock led does not seem to work on text
console.

input4::capsl/trigger was none by default, that can't be right, right?

I tried putting kbd-capslock and input4-capsl there, but that did not
seem to help.

It works with heartbeat trigger, but not with input4-numl
trigger. (But numlock led works ok with that trigger, weird).

vt::capsl/brightness controls capslock led, even when
input4-capsl/trigger is set to input4-numl.

Confused,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
