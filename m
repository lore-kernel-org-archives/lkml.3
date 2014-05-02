Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaEBInZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:43:25 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49263 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaEBInV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:43:21 -0400
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
Date: Fri, 2 May 2014 10:43:20 +0200
X-Google-Sender-Auth: CS3mR1GKgX29ER2_M-kjFA1A_yY
Message-ID: <CAELBmZBhXDdtjAiK16qJex7deY1SB-2uED3DfjRGhGN4RrYFaw@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Szeredi Miklos <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 4:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, May 01, 2014 at 11:42:52AM +0200, Miklos Szeredi wrote:

>> - "bool foo = flag & FLAG" looks suspicious.  Is this guaranteed not to
>>   overflow?
>
> What do you mean, overflow?  It's not a 1-bit unsigned int; conversion to
> _Bool is different (which is the only reason why it's more than mere
> syntax sugar).  See C99 6.3.2.1 ("When any scalar value is converted
> to _Bool, the result is 0 if the value compares equal to 0; otherwise,
> the result is 1").

Ah, didn't know that.

Thanks,
Miklos
