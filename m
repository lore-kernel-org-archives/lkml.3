Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3EWCwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:52:34 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34522 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab3EWCwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:52:33 -0400
Date: Wed, 22 May 2013 21:52:30 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Linux 3.10-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFy7yAEwx1tQo2Ni0VZvAx2Q2d06zWantv1OAmnd=vUhaw@mail.gmail.com>
	(from torvalds@linux-foundation.org on Mon May 20 16:54:53 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369277550.2776.10@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 04:54:53 PM, Linus Torvalds wrote:
> So it's been just over a week, and -rc2 is out.
> 
> For being an -rc2, it's not unreasonably sized, but I did take a few
> pulls that I wouldn't have taken later in the rc series. So it's not
> exactly small either. We've got arch updates (PPC, MIPS, PA-RISC),
> we've got driver fixes (net, gpu, target, xen), and we've got
> filesystem updates (btrfs, ext4 and cepth - rbd).
> 
> And various random small fixes. Shortlog appended, it should get
> smaller and more readable going forward.

I still need this to build uClibc with this kernel:

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 1a85940..e294c77 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -1,7 +1,6 @@
  #ifndef _UAPI__LINUX_NETLINK_H
  #define _UAPI__LINUX_NETLINK_H

-#include <linux/kernel.h>
  #include <linux/socket.h> /* for __kernel_sa_family_t */
  #include <linux/types.h>

Previously reported here:

http://lkml.indiana.edu/hypermail/linux/kernel/1305.2/01452.html

Rob