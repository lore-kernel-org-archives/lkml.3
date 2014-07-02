Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaGBWUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:20:23 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:62318 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaGBWUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAF4BF-SZp64iD_imNH42qXaENWbNzgBOiVaSeUMMBScrSc6VEw@mail.gmail.com>
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
 <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com>
 <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com>
 <53B14E9E.3040505@vmware.com> <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com>
 <53B15A94.3010402@vmware.com> <CAF4BF-TiHkaaOejH6p1QnnepfOxmvirds3vQD2YdXih_6kkUpQ@mail.gmail.com>
 <CAF4BF-T8a_Y=uW7r_g0WKpABHFH=GhX0hNAQMsG9o=DX4JF6qg@mail.gmail.com>
 <53B16492.6040006@vmware.com> <CAF4BF-R_b0_7tzqsMu0UENYtdQ7P=2x6ELLhMB38_4u9Fc58RQ@mail.gmail.com>
 <53B38780.5020808@vmware.com> <CAF4BF-SZp64iD_imNH42qXaENWbNzgBOiVaSeUMMBScrSc6VEw@mail.gmail.com>
From: Christopher Friedt <chrisfriedt@gmail.com>
Date: Wed, 2 Jul 2014 18:19:58 -0400
Message-ID: <CAF4BF-RD1uyRz66XRHhQ_vFjwESFS+ptuGxhfitcasB1BH2Viw@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        linux-graphics-maintainer@vmware.com, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least one source has reported that vmwgfx_fb.c::vmw_fb_check_var()
is not even a code path that is traversed when the bug occurs (i.e.
inserted unique log message -> never seen in logs).

Also, everyone encountering the bug seems to be on a slightly older
version of VMWare Player. It does not seem to occur with "modern"
versions of VMWare Player, and might even be limited to Windows hosts.

So I think at this point, I can conclusively say It Wasn't Me™.
However, I am a bit concerned with this bug, so I'm going to follow up
on it within the Ubuntu community and help out in any way that I can.

In any case... I do have a pretty cool patch that enables (something
like) double-buffering on vmwgfx_fb - care to see it!!??

Hehehe... I'm serious! :-)

Cheers,

C
