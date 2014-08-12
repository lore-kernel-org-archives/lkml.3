Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaHLOcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:32:33 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:42227 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaHLOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:32:30 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.17.117]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 12 Aug 2014 17:32:10 +0300
Message-ID: <CAK=WgbaQcv22Ch64LSSOw7onwnkuGNfJGxmfzAOFffv=8qLLfw@mail.gmail.com>
Subject: [GIT PULL] hwspinlock for 3.17
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Anna, Suman" <s-anna@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git
tags/hwspinlock-3.17

for you to fetch changes up to ceca89e89ee21a3af050c3ea4c634b3be0e34d51:

  hwspinlock: enable OMAP build for AM33xx, AM43xx & DRA7xx
(2014-07-29 11:46:28 +0300)

----------------------------------------------------------------
Two small hwspinlock changes for better OMAP support, coming
from Suman Anna.

----------------------------------------------------------------
Suman Anna (2):
      hwspinlock/omap: enable module before reading SYSSTATUS register
      hwspinlock: enable OMAP build for AM33xx, AM43xx & DRA7xx

 drivers/hwspinlock/Kconfig           |  2 +-
 drivers/hwspinlock/omap_hwspinlock.c | 27 ++++++++++++++++++++-------
 2 files changed, 21 insertions(+), 8 deletions(-)
