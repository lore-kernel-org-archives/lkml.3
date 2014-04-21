Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaDUOZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:25:41 -0400
Received: from mail001.aei.ca ([206.123.6.130]:58040 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaDUOZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:25:33 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [git pull] drm fixes
Date: Mon, 21 Apr 2014 10:25:25 -0400
Message-ID: <3853215.bjCM91curD@grover>
Organization: me
User-Agent: KMail/4.13 (Linux/3.14.1-1-ARCH; KDE/4.13.0; x86_64; ; )
In-Reply-To: <20140419190305.GA267@x4>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie> <20140419190305.GA267@x4>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2014 21:03:05 Markus Trippelsdorf wrote:
> On 2014.04.19 at 08:19 +0100, Dave Airlie wrote:
> > 
> > Unfortunately this contains no easter eggs, its a bit larger than I'd 
> > like, but I included a patch that just moves code from one file to another 
> > and I'd like to avoid merge conflicts with that later, so it makes it seem 
> > worse than it is,
> 
> > Christian König (2):
> >       drm/radeon: apply more strict limits for PLL params v2
> >       drm/radeon: improve PLL params if we don't match exactly v2
> 
> commit f8a2645ecede4eaf90b3d785f2805c8ecb76d43e
> Author: Christian König <christian.koenig@amd.com>
> Date:   Wed Apr 16 11:54:21 2014 +0200
> 
>     drm/radeon: improve PLL params if we don't match exactly v2
> 
> The commit above causes my monitor to just stay blank after boot.
> No framebuffer, no Xorg, no nothing. I'm using a Radeon RS780.

I have the same symptoms with rc2 and a r7 260x using display port.  I cannot 
seem to get a dmesg of a failure (I _really_ need to figure out how to add
a serial console).  I'll try reverting once I figure out how to get pacman to
do a revert when building from git.

Thanks,
Ed Tomlinson
