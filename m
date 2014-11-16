Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaKPIie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 03:38:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49748 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaKPIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 03:38:33 -0500
Date: Sun, 16 Nov 2014 09:38:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: dtb size limit? was Re: Tiny dts change breaks boot on n900
Message-ID: <20141116083831.GB30646@amd>
References: <20141110123118.GA31134@amd>
 <20141110125806.GA16650@amd>
 <5460D8F4.9000507@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5460D8F4.9000507@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-11-10 15:25:40, Andreas Färber wrote:
> Am 10.11.2014 um 12:58 schrieb Pavel Machek:
> > If I replace the blo[ck] below with
> > 
> >  a = <1>;
> >  b = <2>;
> >  c = <3>;
> >  d = <4>;
> > 
> > Resulting kernel boots. Replacing it with
> > 
> >  a-really-long-attribute-name-hopefully-this-breaks-stuff = <1>;
> >  b = <2>;
> >  c = <3>;
> >  d = <4>;
> > 
> > Breaks the boot. I'm using dtb append option. Any ideas? Nonbooting
> > dtb is 68910 bytes.
> 
> Did you verify that your initrd, if any, does not overlap the end of the
> kernel when loading it from the bootloader?

I don't use initrd, so this can't be it. Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
