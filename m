Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbbAFW4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:56:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52426 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbAFW4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:56:17 -0500
Date: Tue, 6 Jan 2015 23:56:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106225614.GA31990@amd>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
 <20150106205730.GA6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106220805.GD13902@amd>
 <20150106222717.GC6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106224622.GA13752@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106224622.GA13752@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-06 16:46:22, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Jan 07, 2015 at 12:27:17AM +0200, Aaro Koskinen wrote:
> > But I'm mounting it from userspace (using builtin initramfs inside
> > zImage), with a poll loop that waits for a device to appear. Maybe if you
> > do it from kernel you need to use root wait/delay etc. options?
> 
> yeah, rootwait should do it.

No, rootwait does not solve it. Try it. Tested many times. (And yes,
you need to actually fool the rear cover sensor or close the phone.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
