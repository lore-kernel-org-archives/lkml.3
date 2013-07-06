Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3GFVHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 17:07:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:48921 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GFVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 17:07:22 -0400
Date: Sat, 6 Jul 2013 23:07:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: John Stultz <john.stultz@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCHv4 08/10] clocksource: sun4i: Remove TIMER_SCAL variable
In-Reply-To: <20130706081045.GY2959@lukather>
Message-ID: <alpine.DEB.2.02.1307062301481.32106@ionos.tec.linutronix.de>
References: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com> <1373062725-19625-9-git-send-email-maxime.ripard@free-electrons.com> <alpine.DEB.2.02.1307060031030.32106@ionos.tec.linutronix.de> <20130706081045.GY2959@lukather>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jul 2013, Maxime Ripard wrote:
> On Sat, Jul 06, 2013 at 01:17:41AM +0200, Thomas Gleixner wrote:
> > I really recommend that you go out for lots of beer/wine NOW and
> > resume reading this mail when you recovered from that.
> > 
> > I definitely appreciate your responsivness to feedback, but please go
> > back and read my reply to the previous version of this patch
> > carefully. You might eventually find out that I pointed you to another
> > redundant clk_get_rate() call in that code.
> > 
> > After you did this, please go through the other patches in that series
> > and check how many new instances of clk_get_rate() calls you add down
> > the road. I did not even bother to look whether you cleaned it up
> > between v3 and v4, but I'm quite sure you did not. If I'm wrong, I owe
> > you a beer at the next conference.
> 
> Wow, you really want me to drink, do you? :)

Taking a break really helps :)

> Actually, I did clean up. The other user you spotted that was previously
> introduced in the patch 4/10, and if you take a look at it, you'll see
> that it actually uses the rate variable like you suggested.

Ah, missed that :)
 
> Now, your mail made me realize that patch 10 introduced a direct
> clk_get_rate call, that I forgot to cleanup. After applying these
> patches, it's the only user left.

So no beer for you!
 
> I'll send a v5. Do you have any additionnal comments on those patches to
> avoid wasting more electrons?

No, I just wanted to make you aware that sending patches faster than I
can review them is not really helpful, unless the fast new version is
perfect. 

Thanks,

	tglx
