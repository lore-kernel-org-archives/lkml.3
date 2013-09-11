Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3IKC0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:26:13 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:47998 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3IKC0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:26:10 -0400
MIME-Version: 1.0
Date: Tue, 10 Sep 2013 19:26:10 -0700
X-Google-Sender-Auth: TtnTRPYSyXmFg_UQYFAuTLXL_Ig
Message-ID: <CA+55aFyTpb8k523=qqeO9LMvs6EgmaRdohip0FcTX7Qip1VyxA@mail.gmail.com>
Subject: RIP - dead harddisk..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Peter Anvin <hpa@linux.intel.com>, Guenter Roeck <linux@roeck-us.net>,
        Dave Airlie <airlied@linux.ie>, Bruce Fields <bfields@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timing absolutely sucks, but it looks like the SSD in my main
workstation just died on me.

I had pushed out _most_ of my pulls today, so realistically I didn't
lose a lot of work. However, any people having outstanding pull
requests or patches that they expected me to merge that are not in the
current tree on git.kernel.org, you may want to re-send the email,
because I had archived emails as I merged them, and I may not have
found all the ones that never made it out.. I know a few involved,
but....

That said, wait until tomorrow. I'll try to see if I can recover the
disk, but right now my machine refuses to even see the boot sector on
it, and tries to boot from the network instead. So I'm not all that
hopeful.

If worst comes to worst, I'll just do the last next days of the merge
window on the laptop that I was planning on finishing it off with
anyway, since I have travel coming up. At least this didn't happen at
the very beginning of the merge window...

                   Linus
