Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3LUDWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 22:22:22 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44244 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3LUDWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 22:22:21 -0500
MIME-Version: 1.0
In-Reply-To: <20131220212302.5ffd6260@corrin.poochiereds.net>
References: <CA+55aFzYZEmNEHQVgWS6usVnDVi-8ar7ZzP+eUGrqoO2OP66kA@mail.gmail.com>
	<20131220173935.0812cc4e.akpm@linux-foundation.org>
	<CA+55aFwwXKAs0dyJJ2FAcJj-okqqLYQsPsSask1p_nXvyrtWXw@mail.gmail.com>
	<20131220212302.5ffd6260@corrin.poochiereds.net>
Date: Fri, 20 Dec 2013 19:22:20 -0800
X-Google-Sender-Auth: 2BGYCiO2TWA6M5V4li-Dg1IlhZs
Message-ID: <CA+55aFw41HiuKiRDzEipSWZ-8KUHapaenfCXn3Xi4TZHns0iRQ@mail.gmail.com>
Subject: Re: Broken initrd compression settings in 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, P J P <ppandit@redhat.com>,
        Jan Beulich <JBeulich@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 6:23 PM, Jeff Layton <jlayton@redhat.com> wrote:
>
> But, what's the point of setting INITRD_COMPRESS-y at all if you're not
> going to export INITRD_COMPRESS? Would it be better to just remove that
> entire block in the Makefile (i.e. just revert PJP's patch?)

I ended up committing the minimal change that I was testing, leaving
the core code in, just disabling it so that everything works for me on
F20.

I may happen to think that the kernel shouldn't try to pick the
format, but I'm willing to leave the door open for somebody arguing
for that approach.

               Linus
