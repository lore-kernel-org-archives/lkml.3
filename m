Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaDXWPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:15:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531AbaDXWPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:15:13 -0400
Date: Fri, 25 Apr 2014 00:15:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [bisect result] Re: 3.15-rc2: i915 regression: only top 20% of
 screen works in X
In-Reply-To: <20140424220638.GA29385@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.LRH.2.00.1404250013550.30970@twin.jikos.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz> <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com> <20140423220952.GA3627@amd.pavel.ucw.cz> <20140424055023.GA31221@nuc-i3427.alporthouse.com> <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
 <20140424194037.GB30333@amd.pavel.ucw.cz> <20140424201521.GN31221@nuc-i3427.alporthouse.com> <20140424220638.GA29385@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Pavel Machek wrote:

> > > And we have a winner here :-)
> > > 
> > > Ok, it was not as painfull as I feared.
> > > 
> > > It does not revert cleanly, but doing it by hand was not that bad.
> > 
> > Oh my. That is bizarre, can you check whether you have
> > 
> > commit 9991ae787a0c87fe7c783b4b6f4754c3cdbb6213
> 
> Yes, with that commit, graphics is back to working state. Please push
> it to mainline soon -- it fixes a regression. Feel free  to add

Alright, most of my testing has been done with that commit present 
(obviously, as I've been using Chris' branch that has this incorporated), 
so I have a different ring initialization problem than Pavel had.

-- 
Jiri Kosina
SUSE Labs

