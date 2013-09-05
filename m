Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3IEXUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 19:20:01 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:38983 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3IEXT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 19:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFybVR6MqWpQfTu3jK8mgSg8Z53gz0Ah77ZK1+40Fx=FsQ@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
	<20130905153243.43d0346e@jbarnes-desktop>
	<CA+55aFybVR6MqWpQfTu3jK8mgSg8Z53gz0Ah77ZK1+40Fx=FsQ@mail.gmail.com>
Date: Thu, 5 Sep 2013 16:19:58 -0700
X-Google-Sender-Auth: bzhTQ2Tfjs9okvDTRSh3IlAFp30
Message-ID: <CA+55aFwOme_LD6qqmzdEQ6AXiK8My7PWU1y5VV2tLgkO1HU7xg@mail.gmail.com>
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

On Thu, Sep 5, 2013 at 3:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I've booted a few times since (it's the merge window, so I boot fairly
> frequently), and it hasn't happened again...

.. and of course, after I say that, on the very next boot it then
happened three times in a row until it magically didn't happen.

So I've decided I'm going to try to bisect this after all. I've done
enough pulls for today anyway, I guess. Let's see if I can bisect it
by just trying to boot many times each try.

                Linus
