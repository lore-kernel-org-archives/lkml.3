Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3IQH0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:26:47 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59799 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3IQH0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:26:43 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 17 Sep 2013 09:26:41 +0200
Message-ID: <CA+icZUWPG2PQx3-c=UeRsad=qbPY=iXyqSGpEhD8RdXdHkHuzQ@mail.gmail.com>
Subject: Re: linux-next stats (Was: Linux 3.12-rc1)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I am subscribed to linux-next but I did not receive [1].
If you did not CC linux-next, can you do this next time?
Thanks.

Your stats have a lot of number, I am not sure if I read/interpret
them correctly.
Just one number is interesting for me:
How many commits/patches were taken from Linux-next tree 1:1 into v3.12-rc1?
Percentage of them to the total number of commits v3.11..v3.12-rc1?
IOW: How successful is Linux-next?

I am irritated by the number of SHA-IDs vs. number of subject-lines.
If those patches went into v3.12-rc1 from Linux-next both should be
nearly the same.
Can you explain that?

How many trees of maintainers/submaintainers were taken from their
"for-next" trees [2]?
IOW: Without any changes, special preperations "for-linus" (aka
"for-v3.12-rc1")?
IOW #2: How effective work maintainers :-)!

To summarize: I am interested in what went from -next to -rc1 in the
last merge-window.

Thanks for clarification in advance.

Regards,
- Sedat -

P.S.: While digging through the scripts-dir I found "diffconfig". For
your stats I highly recommend to see which Kconfig-options are 1. new
2. changed (name or Y|M|N, especially M->Y).


[1] http://marc.info/?l=linux-kernel&m=137939708327120&w=2
[2] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Next/Trees
