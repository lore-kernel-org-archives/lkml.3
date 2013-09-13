Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3IMAPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:15:40 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:58289 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab3IMAPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:15:37 -0400
MIME-Version: 1.0
Date: Thu, 12 Sep 2013 17:15:37 -0700
X-Google-Sender-Auth: TLg-mSgrCJhZU4pG0K52qZarv7o
Message-ID: <CA+55aFwNdeww5jX2+oKG5emB59nazzV5YpvZt8qULVqwCeNdxg@mail.gmail.com>
Subject: Heads up about 3.12 merge window..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is just a heads-up that while I haven't actually closed the
merge window yet, I was really close to deciding to just make this one
a short one. I'm going to be on the road for the next few days and
then at LinuxCon US later next week, and I've tried very hard to merge
everything I had pending in time for that (despite my machine
mishaps).

And I have indeed merged everything that's come in, as far as I can
tell from the current state of my mailbox.

Now, what that means is that if you are a maintainer that hasn't
already sent in your pull request for 3.12, you had better have a good
excuse for why you left it until the last few days. On the other hand,
if you _have_ sent me a pull reqeust, and it hasn't shown up, ping me
separately, we've had those things caught in spam boxes etc, and I
might just have missed it.

Because if you don't have a good excuse and it's a big pull with lots
of development that you just left until very late in the merge window
to make it inconvenient for me, it's going to wait until 3.13.

Here's to hoping everybody just goes "Whew, good that I sent my pull
request early".

And in fact there really shouldn't be anything pending afaik. I've
already merged more commits than was in linux-next.

                  Linus
