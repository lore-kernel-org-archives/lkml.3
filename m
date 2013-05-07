Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3EGMEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:04:50 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:50398 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3EGMEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:04:49 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.230.33]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 7 May 2013 15:04:27 +0300
Message-ID: <CAK=WgbbLUya4MQeh3h6v3a8LcTryJ8H4P7uLK3u9vKBvQey=ag@mail.gmail.com>
Subject: [GIT PULL] hwspinlock for 3.10
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <v-stehle@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git
tags/hwspinlock-3.10

for you to fetch changes up to 8ae053d62e88c400330ebaf27558bf02dde5a1fa:

  hwspinlock/omap: support OMAP5 as well (2013-04-05 09:11:17 +0300)

----------------------------------------------------------------
A single patch from Vincent extending OMAP's hwspinlock support to OMAP5.

----------------------------------------------------------------
Vincent Stehlé (1):
      hwspinlock/omap: support OMAP5 as well

 drivers/hwspinlock/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
