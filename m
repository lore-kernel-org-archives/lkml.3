Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbaDXWGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:06:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38672 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaDXWGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:06:39 -0400
Date: Fri, 25 Apr 2014 00:06:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: Re: [bisect result] Re: 3.15-rc2: i915 regression: only top 20% of
 screen works in X
Message-ID: <20140424220638.GA29385@atrey.karlin.mff.cuni.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
 <20140423220952.GA3627@amd.pavel.ucw.cz>
 <20140424055023.GA31221@nuc-i3427.alporthouse.com>
 <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
 <20140424194037.GB30333@amd.pavel.ucw.cz>
 <20140424201521.GN31221@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424201521.GN31221@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 24, 2014 at 09:40:38PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > And if you can indeed reliably reproduce this a bisect could be really useful.
> > 
> > And we have a winner here :-)
> > 
> > Ok, it was not as painfull as I feared.
> > 
> > It does not revert cleanly, but doing it by hand was not that bad.
> 
> Oh my. That is bizarre, can you check whether you have
> 
> commit 9991ae787a0c87fe7c783b4b6f4754c3cdbb6213

Yes, with that commit, graphics is back to working state. Please push
it to mainline soon -- it fixes a regression. Feel free  to add

Tested-by: Pavel Machek <pavel@ucw.cz>

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
