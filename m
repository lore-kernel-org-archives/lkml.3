Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3CCTgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 14:36:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab3CCTgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 14:36:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: UAPI: The end is nigh!
Date: Sun, 03 Mar 2013 19:36:18 +0000
Message-ID: <23533.1362339378@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

You'll be glad to here that the end is nigh for the UAPI patches.  Only the
fbdev/framebuffer piece remains now that the SCSI stuff has gone in.

As far as I can tell, no changes have been merged that affect the UAPI parts
of the include/video headers, so my previous request should still be good to
go.

David
---
Here are the UAPI disintegration bits for the fbdev drivers.  It appears that
Florian hasn't had time to deal with my patch, but back in December he did say
he didn't mind if I pushed it forward.  I recommend pulling it after any other
fbdev stuff and I can easily regenerate it if necessary.
---
The following changes since commit 1800098549fc310cffffefdcb3722adaad0edda8:

  ARM: OMAP: Fix build breakage due to missing include in i2c.c (2012-12-20 08:43:25 -0800)

are available in the git repository at:

  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-fbdev-20121220

for you to fetch changes up to b889fcf63cb62e7fdb7816565e28f44dbe4a76a5:

  UAPI: (Scripted) Disintegrate include/video (2012-12-20 17:14:26 +0000)

----------------------------------------------------------------
UAPI disintegration 2012-12-20

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/video

 include/uapi/video/Kbuild    |   3 +
 include/uapi/video/edid.h    |   9 ++
 include/uapi/video/sisfb.h   | 209 +++++++++++++++++++++++++++++++++++++++++++
 include/uapi/video/uvesafb.h |  60 +++++++++++++
 include/video/Kbuild         |   3 -
 include/video/edid.h         |   7 +-
 include/video/sisfb.h        | 189 +-------------------------------------
 include/video/uvesafb.h      |  58 +-----------
 8 files changed, 284 insertions(+), 254 deletions(-)
 create mode 100644 include/uapi/video/edid.h
 create mode 100644 include/uapi/video/sisfb.h
 create mode 100644 include/uapi/video/uvesafb.h


