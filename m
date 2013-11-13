Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3KMNxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:53:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:53463 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab3KMNxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:53:12 -0500
Date: Wed, 13 Nov 2013 14:53:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: 3.12 fixes
In-Reply-To: <20131113103632.GV14892@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1311131358310.30673@ionos.tec.linutronix.de>
References: <528234B9.7080402@linaro.org> <20131112183553.GQ14892@pengutronix.de> <alpine.DEB.2.02.1311122316270.30673@ionos.tec.linutronix.de> <20131113103632.GV14892@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-646764179-1384350786=:30673"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-646764179-1384350786=:30673
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 13 Nov 2013, Uwe Kleine-König wrote:
> On Tue, Nov 12, 2013 at 11:57:46PM +0100, Thomas Gleixner wrote:
> > The whole misery starts that you decided to play maintainer and grab
> > some patches from the mailinglist and then offering them via a pull
> > request to me and others. Finally you tricked Daniel to take them,
> >From my POV this isn't "playing maintainer". You stopped reacting on the
> issue and I thought I make it easier for you (and others) to handle the
> patches in case you didn't take because of being busy with other stuff.

Yes, I vanished for a few weeks because I was busy otherwise. Where is
the problem? The world was still turning and the fix was not a highly
critical issue.

And your "make it easier" thing is utter bullshit. It takes me less
time to apply a single patch from mail than pulling a tree and
verifying the commit.

Aside of that, core code goes always directly through me and not via
Daniel.

Dammit, there are established workflows and there is no reason, except
for a highly critical bug fix to circumvent them. And if such a
situation happens, then the correct thing is to resend the patch to
Andrew and Linus and explaining, why its critical and can't wait for
the lazy maintainer to reappear.

Me and others have observed your busybody behaviour often enough. It
does not really earn you trust and respect.

Just for the record: I'm not pulling anything from you and I'm not
going to pull a tree from my submaintainers which contains a merge
from you.

Thanks,

	tglx
--8323329-646764179-1384350786=:30673--
