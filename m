Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaEBVEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:04:30 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:57307 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaEBVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:04:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140501143434.GA18016@ZenIV.linux.org.uk>
References: <20140430211206.GU18016@ZenIV.linux.org.uk>
	<20140430221238.GV18016@ZenIV.linux.org.uk>
	<CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
	<CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
	<20140430234341.GX18016@ZenIV.linux.org.uk>
	<CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
	<20140501025105.GY18016@ZenIV.linux.org.uk>
	<CA+55aFzN=ERrtWUwAQv0ry-ZzX2k7dz3JZQT6q5zjp_ABwMg6Q@mail.gmail.com>
	<20140501031251.GZ18016@ZenIV.linux.org.uk>
	<20140501094252.GE3113@tucsk.piliscsaba.szeredi.hu>
	<20140501143434.GA18016@ZenIV.linux.org.uk>
Date: Fri, 2 May 2014 14:04:27 -0700
X-Google-Sender-Auth: 1iUFODvhZlgqPGxt9KK4AeUrm08
Message-ID: <CA+55aFy-Qg+THp5u7vfS58Hx2SRXJ8Lr8Qp8U5ZTn1We5mk7SQ@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 7:34 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, fixed and pushed (both branches).

Al, can you send a real pull request (the "both branches" part in
particular makes me worry about which one you think is right), because
I suspect by now we just need to get this wider testing.

              Linus
