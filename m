Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbaKTKRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:17:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58278 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbaKTKRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:17:20 -0500
Date: Thu, 20 Nov 2014 11:17:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: voice calls on N900 working (off-line) was Re: N900 modem
 support in 3.18-rc1
Message-ID: <20141120101718.GA8128@amd>
References: <20141106180335.GA21513@earth.universe>
 <20141106225005.GA14002@amd>
 <201411070001.46481@pali>
 <545C6F14.8050303@gmail.com>
 <20141113162420.GB8512@xo-6d-61-c0.localdomain>
 <5465A977.4030605@gmail.com>
 <20141114172008.GB12250@earth.universe>
 <54665E02.8050108@gmail.com>
 <20141114215749.GA19023@earth.universe>
 <20141120101320.GA6356@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120101320.GA6356@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Ok, so realtime audio does not work due to some pulseaudio problems,
> but I was able to record a (silent) call and then replay it with 
> 
> pacat --rate 4000 ../../../pulseaudio2.raw
> 
> on my PC. I have yet to do some testing on the microphone side.

Did someone get pulseaudio to work on n900?

It somehow works for me, but not enough to actually produce sound.

root@n900:/my# pacat /my/pulseaudio2.raw 
Connection failure: Connection refused
pa_context_connect() failed: Connection refused
root@n900:/my# pacmd
Welcome to PulseAudio! Use "help" for usage information.
>>> list-modules
22 module(s) loaded.
    index: 0
    name: <module-device-restore>
    argument: <>
    used: -1
    load once: yes
...

mpg123 actually works ok after adjusting the mixers.

Any ideas?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
