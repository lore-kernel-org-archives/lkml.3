Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3ERUsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 16:48:15 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:47821 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab3ERUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 16:48:13 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 18 May 2013 13:47:49 -0700
X-Google-Sender-Auth: PnAuG_-H9cI-Le9VIUji04-VCKA
Message-ID: <CAB=NE6WmJKV0UhHBuOrwfvPuEdxbojRMx_eDutS-W3RaKoU9Hw@mail.gmail.com>
Subject: [ANN] compat-drivers renamed to backports
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks as you may already know compat-drivers was renamed to backports
to avoid any confusion with the in-kernel compat code that deals with
32/64 bit compat work and due to some huge amount of changes that went
into the project recently thanks mainly to Johannes. The new tree is
available here:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/backports.git

This tree doesn't have the old stable branches yet but I'll merge them
soon. Use the master branch for ongoing linux-next daily development.
We used to have compat and compat-drivers, with this new rework we
just use one tree.

Contrary to the old way to doing things you can't any longer use the
base tree to compile anything within the same directory. You're now
expected to take things out. The way to generate a new tree to compile
as an example:

./gentree.py /home/mcgrof/linux-next/ /home/mcgrof/build/backports-20130501

As it stands we have tested backports master up to next-20130502. This
leaves 11 more next tags to catch up to linux-next. We're behind given
the huge amount of work that went into this development cycle.
Fortunately though we're now caught up with Linus though and this
means a new branch for a stable release is due which I'll announce
next.

  Luis
