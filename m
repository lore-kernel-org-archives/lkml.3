Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3BUNtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:49:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab3BUNta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:49:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] UAPI disintegration for the framebuffer layer
Date: Thu, 21 Feb 2013 13:49:24 +0000
Message-ID: <7511.1361454564@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Here are the UAPI disintegration bits for the fbdev drivers.  It appears that
Florian hasn't had time to deal with my patch, but back in December he did say
he didn't mind if I pushed it forward.  I recommend pulling it after any other
fbdev stuff and I can easily regenerate it if necessary.

David
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
