Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3EGMFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:05:18 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:53824 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab3EGMFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:05:16 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.230.33]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 7 May 2013 15:04:54 +0300
Message-ID: <CAK=WgbbuJt4V2c_hqSzcqDwts6J7EQvD5CkoK95QqxoqboS2Fg@mail.gmail.com>
Subject: [GIT PULL] rpmsg for 3.10
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tivy, Robert" <rtivy@ti.com>, Suman Anna <s-anna@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git tags/rpmsg-3.10

for you to fetch changes up to 397944df3290ddc46dcc6a08cd71fb560700431b:

  rpmsg: fix kconfig dependencies for VIRTIO (2013-04-21 16:32:29 +0300)

----------------------------------------------------------------
A small pull request consisting of:
- Make rpmsg process all pending messages instead of just
  one, from Robert Tivy
- Fix Kconfig dependency on VIRTUALIZATION, from Suman.
  Note: this was submitted late during the 3.9 rc cycle and it
  seemed appropriate to wait with it for the merge window.
- Belated addition of an rpmsg entry to the MAINTAINERS file.
  People seem to look for this.

----------------------------------------------------------------
Ohad Ben-Cohen (1):
      MAINTAINERS: add rpmsg entry

Robert Tivy (1):
      rpmsg: process _all_ pending messages in rpmsg_recv_done

Suman Anna (1):
      rpmsg: fix kconfig dependencies for VIRTIO

 MAINTAINERS                      |  8 +++++++
 drivers/rpmsg/Kconfig            |  1 +
 drivers/rpmsg/virtio_rpmsg_bus.c | 49 ++++++++++++++++++++++++++++------------
 3 files changed, 44 insertions(+), 14 deletions(-)
