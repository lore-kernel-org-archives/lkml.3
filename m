Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3IEWbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:31:35 -0400
Received: from oproxy6-pub.mail.unifiedlayer.com ([67.222.54.6]:57877 "HELO
	oproxy6-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752158Ab3IEWbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:31:33 -0400
Date: Thu, 5 Sep 2013 15:32:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Beauchesne, Gwenole" <gwenole.beauchesne@intel.com>,
        Sean V Kelley <sean.v.kelley@intel.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
Message-ID: <20130905153243.43d0346e@jbarnes-desktop>
In-Reply-To: <CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013 12:18:32 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Sep 5, 2013 at 3:41 AM, Dave Airlie <airlied@linux.ie> wrote:
> >
> > i915: Haswell PC8+ support and eLLC support, HDMI 4K support, initial per-process VMA pieces,
> >       watermark reworks, convert to generic hdmi infoframes, encoder reworking, fastboot support,
> 
> Hmm.
> 
> The first time I booted this, I just got a black screen on my Haswell
> desktop when X11 started up.  I could ctrl-alt-BS and ctrl-alt-del to
> reboot the machine, and neither the Xorg.0.log nor the dmesg contained
> anything interesting.

Did the console come back after ctl-alt-bs?  Or was it just a blind
reboot?  Troubling that it doesn't happen again...

> I was about to try to bisect it, but decided to see how repeatable it
> was, and it didn't happen again. But it also hasn't ever happened
> before, so I'm a bit worried.
> 
> This is with the DP cable, which has made my other Haswell issues go away.
> 
> I'm also a bit bummed that hw acceleration of video doesn't seem to
> work on Haswell, meaning that full-screen is now a jerky mess. I fear
> that that is user-space libraries/X.org, but I thought I'd mention it
> in the hope of getting a "oh, it's working for us, you'll get a fix
> for it soon".

AFAIK we have libva support out there for HSW.  The trick is getting
your stack to actually use it.  Gwenole or Sean may be able to help.

> Because my shiny new 65W haswell is really nice and does a "make
> allmodconfig" in half the time of my old machine, but the GPU side has
> been something of a step backwards...

Well we definitely don't want that...

-- 
Jesse Barnes, Intel Open Source Technology Center
