Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3AYCDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:03:38 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:61874 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab3AYCDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:03:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9txUNG_CeK+YBhcA_47BVv4Z2GAmEC_J59cY+D9nRgv54A@mail.gmail.com>
References: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
 <CA+55aFxzDv0emWgyde7iEWpgZarAGaExrKbEHFr-UcbhoeH_Cw@mail.gmail.com>
 <CAPM=9tz6_=k1Ze5h2935-W59BCVy9KXA_z6t8inW6_-Cxw244Q@mail.gmail.com> <CAPM=9txUNG_CeK+YBhcA_47BVv4Z2GAmEC_J59cY+D9nRgv54A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Jan 2013 17:57:30 -0800
X-Google-Sender-Auth: U31zICwgmlmgDAidI3qhrFIdv-4
Message-ID: <CA+55aFy+JXjB+SXuH3sk2oDcqYtgW2qFbyyO0kf0D+qb13ThQA@mail.gmail.com>
Subject: Re: [git pull] fbcon locking fixes.
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 5:45 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> Okay I've just sent out another fbcon patch to fix the locking harder.
>
> There was a path going into set_con2fb_path if an fb driver was
> already registered, I just pushed the locking out further on anyone
> going in there.
>
> it boots on my EFI macbook here.

Ok, good. Sounds like we'll finally get it fixed, but I'm still too
much of a scaredy-cat to take it for now, so -next it is...

              Linus
