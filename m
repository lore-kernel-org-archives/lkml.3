Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3CDA22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 19:28:28 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:44893 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3CDA20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 19:28:26 -0500
MIME-Version: 1.0
Date: Sun, 3 Mar 2013 16:28:25 -0800
X-Google-Sender-Auth: O59D2GpYyjOJb3lIp9zTtMZlh9g
Message-ID: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
Subject: Linux 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been two weeks (ok, thirteen days, but close enough), and the
merge window is closed, and I've cut the 3.9-rc1 release.

I don't know if it's just me, but this merge window had more "Uhhuh"
moments than I'm used to. I stopped merging a couple of times, because
we had bugs that looked really scary, but thankfully each time people
were on them like paparazzi on Justin Bieber. Special thanks to Peter,
Ted and Rafael (and the people who reported the bugs too!) for being
so responsive. It could have been so much worse.

As usual, there's changes all over the place. We've got two new
architectures (metag and arc), and we've got tons of arm work (as
usual), with even more platforms falling under the generic umbrella.
MIPS tried to keep up by doing whitespace cleanup, but those arm
people with their platform changes kept ahead

And we've got filesystem updates to just about everything out there,
although btrfs (initial raid56 code, snapshot work and fsync
performance) and ext4 (hole punching, extent caches, also fsync
performance) had the big changes.

But most of the updates (~60%) are on the driver side, as usual.  The
bulk is in GPU, networking, staging, pinctrl, sound, but it's all
over.

There is a lot of stuff there, and as usual even the shortlog is
really too big to pst or read through. I'd suggest using git to check
whatever particular area you're interested in..

                       Linus
