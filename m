Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaLJBEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:04:06 -0500
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:41731 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaLJBED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:04:03 -0500
Date: Wed, 10 Dec 2014 02:03:56 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Peter Korsgaard <peter@korsgaard.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org
Subject: Re: [PATCH] Route keyboard LEDs through the generic LEDs layer.
Message-ID: <20141210010356.GA3074@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Peter Korsgaard <peter@korsgaard.com>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
	jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org,
	Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org
References: <20140331122323.GC6044@type.bordeaux.inria.fr>
 <20141015231545.GD3719@type.youpi.perso.aquilenet.fr>
 <201410160129.22012@pali>
 <201412091812.08575@pali>
 <87mw6wshec.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mw6wshec.fsf@dell.be.48ers.dk>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard, le Tue 09 Dec 2014 21:22:03 +0100, a écrit :
>  > I would like you to remind you this patch which is waiting for 
>  > your review since April 2014!
> 
> Hah, I'm pretty sure it dates back to 2010 atleast.

Yes, the first version was posted on February 2010.  There has been some
reviews, and thus a few versions, I've just posted a 4th version which
has been sitting in -mm for some time now.

Samuel
