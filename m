Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3IFA4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 20:56:46 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:59471 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3IFA4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 20:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwOme_LD6qqmzdEQ6AXiK8My7PWU1y5VV2tLgkO1HU7xg@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
	<20130905153243.43d0346e@jbarnes-desktop>
	<CA+55aFybVR6MqWpQfTu3jK8mgSg8Z53gz0Ah77ZK1+40Fx=FsQ@mail.gmail.com>
	<CA+55aFwOme_LD6qqmzdEQ6AXiK8My7PWU1y5VV2tLgkO1HU7xg@mail.gmail.com>
Date: Thu, 5 Sep 2013 17:56:44 -0700
X-Google-Sender-Auth: ZzACpQ7wkqIuDbFIWDEA5uT1-Xg
Message-ID: <CA+55aFyy_pKt07MgB9PzKg-LLKj1PH0q1t8y2Zu42srCyw-W4w@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Beauchesne, Gwenole" <gwenole.beauchesne@intel.com>,
        Sean V Kelley <sean.v.kelley@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 4:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I've decided I'm going to try to bisect this after all. I've done
> enough pulls for today anyway, I guess. Let's see if I can bisect it
> by just trying to boot many times each try.

Ok, it's not the recent drm pull at all. I can't find a good kernel in
the bunch - they all fail eventually.

It may have been going in for as long as I've had this Haswell
machine, and I was just lucky (and not rebooting a lot until in the
merge window - and 4/5 boots work fine).

It may also be user-space and have come in with the mesa update I got
through yum yesterday. So there might be multiple reasons why I saw it
today after the drm pull for the first time.

The black screen - when it happens - happens after the fedora logo has
flashed, and gdm is supposed to start up. I tried reproducing it by
logging out and back in again (to restart X), but that doesn't do it.
Maybe timing-related with boot or just demand-loading of binaries the
first time, whatever.. Or mayby it's something special that gdm does
at startup?

              Linus
