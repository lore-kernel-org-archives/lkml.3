Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaEAWw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:52:56 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:46057 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEAWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140501210522.GC18016@ZenIV.linux.org.uk>
References: <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
	<CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
	<20140430234341.GX18016@ZenIV.linux.org.uk>
	<CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
	<20140501025105.GY18016@ZenIV.linux.org.uk>
	<CA+55aFzN=ERrtWUwAQv0ry-ZzX2k7dz3JZQT6q5zjp_ABwMg6Q@mail.gmail.com>
	<20140501031251.GZ18016@ZenIV.linux.org.uk>
	<20140501094252.GE3113@tucsk.piliscsaba.szeredi.hu>
	<20140501143434.GA18016@ZenIV.linux.org.uk>
	<20140501210233.GB18016@ZenIV.linux.org.uk>
	<20140501210522.GC18016@ZenIV.linux.org.uk>
Date: Thu, 1 May 2014 15:52:54 -0700
X-Google-Sender-Auth: jDHNddugiAKd3dZM5cMPW1ouu9U
Message-ID: <CA+55aFyoXfk3t34NS5vAHqAXWsfDLgc_the_u+PryZt3XKQBKg@mail.gmail.com>
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

On Thu, May 1, 2014 at 2:05 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> ... and so has this one, the bounce being

I actually got all three messages despite the bounces. But I seem to
have gotten at least the first one through lkml.

Your email is lacking SPF or any other authentication, so it may be
gmail being pissy about that, though:

  Received-SPF: none (google.com: viro@ftp.linux.org.uk does not
designate permitted sender hosts) client-ip=195.92.253.2;

especially if your IP is in a block where other people send spam,
gmail has been known to just say "that ISP is clearly bad".

              Linus
