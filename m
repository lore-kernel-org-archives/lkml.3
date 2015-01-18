Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbbARMBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:01:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60574 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbbARMBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:01:42 -0500
Date: Sun, 18 Jan 2015 13:01:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        peter.ujfalusi@ti.com, jarkko.nikula@bitmer.com
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150118120139.GA1509@amd>
References: <20150106170433.GA5408@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106170433.GA5408@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

If you have any idea about playback problems, help would be still
welcome. I'll have to do bisect, otherwise, and it will not be easy.

> In 3.18, sound is nice and clear.
> 
> In 3.19, sound is unusable. It produces nasty tone when it should be
> quiet, and there's at least as much noise as is sound.
> 
> Unfortunately, list of mixers also changed (and there's cca 120
> settings), but a) it does not work with the old list and b) nothing I
> could figure out did make the sound usable. Some setting resulted in
> even more noise.
> 
> Any idea what could have caused it?

I tried audio recording this time.

In 2.6.28-nokia, it is neccessary to set "Input select" na "digital
mic", then it works. Input select being in "playback" option makes it
easy to miss.

In 3.18 and 3.19-rc3, all I can record are zeros.

Does playback/recording work for you on OMAP 3430-based machines?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
