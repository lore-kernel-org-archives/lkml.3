Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaLSXC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:02:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37171 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLSXC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:02:56 -0500
Date: Sat, 20 Dec 2014 00:02:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv4] INPUT: Route keyboard LEDs through the generic LEDs
 layer.
Message-ID: <20141219230253.GA31928@amd>
References: <20141210010214.GZ3074@type.youpi.perso.aquilenet.fr>
 <20141219144641.3a549feb1ee5f2b9400f62cb@linux-foundation.org>
 <20141219225933.GD3049@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141219225933.GD3049@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-19 23:59:33, Samuel Thibault wrote:
> Andrew Morton, le Fri 19 Dec 2014 14:46:41 -0800, a écrit :
> > > Changed in this version:
> > > - Use kcalloc instead of kzalloc
> > > - to avoid any mutex order violation, defer LED update into a work callback.
> > 
> > Confused.  This patch is identical to the one that's presently in -mm.
> 
> Well, yes: I'm submitting the latest version of this patch to Dmitry,
> i.e. including the fixes that happened in the -mm tree.

Andrew, do you think you could send the patch to Dmitry? He has been
ignoring it for way too long... and it should be slightly harder for
him to ignore patch from you...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
