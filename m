Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3GXUjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:39:44 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:53767 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3GXUjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:39:42 -0400
MIME-Version: 1.0
In-Reply-To: <17420057.BAULu67LQ3@vostro.rjw.lan>
References: <BLU0-SMTP125E791F01E26C3D60D7353A6680@phx.gbl>
	<17420057.BAULu67LQ3@vostro.rjw.lan>
Date: Wed, 24 Jul 2013 13:39:35 -0700
X-Google-Sender-Auth: LcS8tl92WKb2fNNnP_UJuSczMVU
Message-ID: <CA+55aFzDgAcrzkkq06Qe9CBbBv6xKMYwPqtwv+ACryRSTRDOSQ@mail.gmail.com>
Subject: Re: Linux 3.11-rc2 [backlight] [ASUS N56VZ]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?B?KiBTQU3DjSAq?= <miaousami@hotmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Aaron Lu <aaron.lu@intel.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Well, there seems to be a number of people who'll be equally unhappy if I don't
> do that.  Unfortunately for you, things work for them without that patch.

So I think we have to revert the behavior back, but I wonder if we
could keep the logic and have a i915 kernel command line option to
enable it.

We did that for a long time with "drm.modeset" and the
"i915.enable_rc6" mess. We still have the "i915.invert_brightness"
thing, although I don't know who actually uses it. But that option is
itself an indication that the i915 driver still has some backlight
issues.

But if that kind of "revert behavior" isn't easy, we need to just
revert the patches entirely.

               Linus
