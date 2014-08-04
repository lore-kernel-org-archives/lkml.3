Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaHDOQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:16:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34837 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaHDOQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:16:16 -0400
Date: Mon, 4 Aug 2014 16:16:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Markus Gutschke <markus@gutschke.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
Message-ID: <20140804141613.GB24261@amd.pavel.ucw.cz>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <CALGCz1oYYkKp1frPF4vExiwqW=euYY8An+Yum4U-qsBc5NyjFg@mail.gmail.com>
 <1405587482.28592.64.camel@rzhang1-toshiba>
 <CALGCz1qzmK_0Mq8JNFYUnGtDGWSqYoHfqv0MKbqG1RySQ4bt6g@mail.gmail.com>
 <1405988531.2455.14.camel@rzhang1-toshiba>
 <CALGCz1okgr4K9S+6NfohM1Y3LregQLEKaj7FuON0xkk7xX1Jhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALGCz1okgr4K9S+6NfohM1Y3LregQLEKaj7FuON0xkk7xX1Jhg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-07-26 08:52:34, Markus Gutschke wrote:
> Sorry for the delay. Remotely debugging kernels over a shared and
> flaky 1MBps terrestrial wireless connection is quite a new experience
> to me.
> 
> In any case, I was able to collect all the data that you asked for. I
> then used "pm-suspend" to put the machine to sleep and asked a helper
> to physically press the power button to wake the computer back up. My
> helper told me that it crashed just as before, and they had to
> power-cycle the machine to bring it back to life.
> 
> Please let me know, what other data I can get for you. And thank you
> very much for putting up with my slow turn-around. I should have much
> better response time again in about two to three weeks when I return
> to civilization.

Was this solved, somehow?

If not, can we revert the patch that causes it?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
