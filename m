Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaF1JA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 05:00:59 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46947 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaF1JA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 05:00:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140625132220.GA20837@nuc-i3427.alporthouse.com>
References: <CAJ7vePCSE3eWTBpzBGY8-e3ZTB0iZARdfMmhRE6LQYaxcFkVqg@mail.gmail.com>
 <20140625132220.GA20837@nuc-i3427.alporthouse.com>
From: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Date: Sat, 28 Jun 2014 11:00:17 +0200
Message-ID: <CAJ7vePDbFBzwMCwOiDaNsoF0jJGwu76KxB4xFgcec2xTJJ3HJw@mail.gmail.com>
Subject: Re: drm/i915 KMS regression in Linux 3.16-rc2 (with git bisect result)
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Tom Van Braeckel <tomvanbraeckel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, ville.syrjala@linux.intel.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> There seems to be a regression in the upcoming Linux 3.16-rc2 release
>> candidate that I bisected down to this first bad commit:
>> [dbb42748ac4929987c1449ecb296b39ef8956b62] drm/i915: Move the C3 LP
>> write bit setup to gen3_init_clock_gating() for KMS.
>
> Can you attach the dmesg with rc2 and dbb4274 reverted?

Hmm, for some reason I started having a hard time reproducing the
issue on commit dbb4274.

I still have it on the 3.16-rc2 though and I'm doing another bisect.

The issue comes and goes during the bisect so let's see where it
leads... perhaps it turns out to be some configuration setting.
