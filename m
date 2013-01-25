Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3AYAyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:54:13 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39595 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab3AYAyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:54:09 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
References: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Jan 2013 16:53:46 -0800
X-Google-Sender-Auth: O08_6Df8jd5OLD3ZQfWiSScaDTk
Message-ID: <CA+55aFxzDv0emWgyde7iEWpgZarAGaExrKbEHFr-UcbhoeH_Cw@mail.gmail.com>
Subject: Re: [git pull] fbcon locking fixes.
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 4:42 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> These patches have been sailing around long enough, waiting for a maintainer
> to reappear, so I've decided enough is enough, lockdep is kinda useful to have.

Last this was tried, these patches failed miserably.

They caused instant lockdep splat and then a total lockup with efifb.
It may be that Takashi's patch helps fix that problem, but it's in no
way clear that it does, so the patch series isn't at all obviously
stable.

Yes, lockdep is indeed "kinda useful", and there clearly are locking
problems in fbdev. But I'm not seeing myself pulling these for 3.8.
They've been too problematic to pull in at this late stage.

              Linus
