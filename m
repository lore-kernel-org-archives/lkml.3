Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab3KJPDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:03:38 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:57940 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3KJPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:03:37 -0500
MIME-Version: 1.0
Date: Sun, 10 Nov 2013 16:03:36 +0100
Message-ID: <CALeOzZ_K0o_h4gJ4w-twL5=-0QjC1XWb=m948wXWwjndr4q_Kw@mail.gmail.com>
Subject: Partially Privileged Applications
From: Shahbaz Youssefi <shabbyx@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

First, please CC replies to myself. Second, this is an RFC.

I've been tampering with an idea for some time now and I've done some
research. Finally, I wrote it down here (a terrible place as it turned
out):

http://shahbaz-youssefi.blogspot.it/2013/11/partially-privileged-applications.html

and would like to know what you think. This idea requires an
improvement to the CPU architectures to allow unifying kernel and user
spaces and perform privileged instructions based on the location of
the instruction rather than a manually switched mode (or via traps).

Please, do take a look at the link. I'm far from a kernel expert so
the idea may not be as rainbows and unicorns as it seems to me right
now. But it also may be. In that case, probably we need a push by
well-known people (i.e., Linus) to get the manufacturers to implement
the feature.

At least from a developer's point of view, with this idea you could
gdb or even valgrind check the drivers in the very least with much
less chance of a kernel oops. How faster can you imagine debugging a
kernel module?

Thanks,
An unfortunate soul who has to deal with buggy kernel modules
