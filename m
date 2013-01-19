Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab3ASNfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 08:35:11 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50870 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3ASNfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 08:35:09 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 19 Jan 2013 14:35:08 +0100
Message-ID: <CA+icZUWtj0iDW+wEWdZPUfKGpLRkdvuTmYz3mw4hVGyvdy_HBw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 18 [ BROKEN tty-next on suspend ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ilya Zykov <ilya@ilyx.ru>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 5:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130117:
>
> Undropped tree: samung
>
> The powerpc tree still had a build failure.
>
> The driver-core tree gained a build failure for which I applied a merge
> fix patch.
>
> The gpio-lw tree gained a build failure so I used the version from
> next-20130117.
>
> The samsung tree lost the majority of its conflicts but gained more
> against the arm-soc and slave-dma tree.
>
> ----------------------------------------------------------------------------
>

[ TO TTY folks ] + [ CC Rafael and linux-pm ML ]

In the end it turned out to be a problem with tty-next (see thread in [1]).
I am hitting the problem reproducibly on PM/suspend.
Rafael gave me some cool help on pm-testing, thanks (see also thread in [1])

Ilya has sent a patch to [3] which needs to be refreshed.
AFAICS also be adapted to the recent changes to tty_port and tty_buf.
But hey, I am no TTY expert so it is up to you.

Hope you will CC me on the patch.

Thanks!

- Sedat -

[1] http://marc.info/?t=135854714000003&r=1&w=2
[2] http://git.kernel.org/?p=linux/kernel/git/gregkh/tty.git;a=shortlog;h=refs/heads/tty-next
[3] http://marc.info/?t=135452868300003&r=1&w=2
