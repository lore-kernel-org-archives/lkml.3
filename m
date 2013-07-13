Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab3GMT46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 15:56:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48359 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3GMT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 15:56:55 -0400
Date: Sat, 13 Jul 2013 21:56:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] omapfb: In omapfb_probe return -EPROBE_DEFER when
 display driver is not loaded yet
Message-ID: <20130713195652.GA29130@amd.pavel.ucw.cz>
References: <1373461739-10168-1-git-send-email-pali.rohar@gmail.com>
 <20130713182733.GA25019@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713182733.GA25019@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> One thing I'd like to know: how do you configure kernel to get output
> on qemu? I was doing CONFIG_DEBUG_LL with specific uart, but that
> needed patching the kernel, you apparently have something more
> clever.

Aha, normal console=ttyO2 option. Got it now :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
