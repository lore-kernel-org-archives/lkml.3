Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaLJFiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 00:38:04 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:41245 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaLJFiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 00:38:03 -0500
MIME-Version: 1.0
Date: Wed, 10 Dec 2014 11:08:01 +0530
Message-ID: <CABb+yY14EGbv4cPUanuZyKZ5=jtkbAsWUX+=auqSrESQ1fFvGw@mail.gmail.com>
Subject: [GIT PULL] Mailbox changes for 3.19
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  http://git.linaro.org/landing-teams/working/fujitsu/integration.git
mailbox-devel

for you to fetch changes up to 86c22f8c9a3b71d42d38bfcd80372de72f573713:

  Mailbox: Add support for Platform Communication Channel (2014-11-27
12:51:09 +0530)

----------------------------------------------------------------
Andrew Bresticker (1):
      mailbox: Don't unnecessarily re-arm the polling timer

Ashwin Chaugule (1):
      Mailbox: Add support for Platform Communication Channel

Sudeep Holla (1):
      mailbox: add tx_prepare client callback

Suman Anna (1):
      mailbox/omap: adapt to the new mailbox framework

 .../devicetree/bindings/mailbox/omap-mailbox.txt   |  23 ++
 drivers/mailbox/Kconfig                            |  12 +
 drivers/mailbox/Makefile                           |   2 +
 drivers/mailbox/mailbox.c                          |  19 +-
 drivers/mailbox/mailbox.h                          |  14 +
 drivers/mailbox/omap-mailbox.c                     | 346 ++++++++++--------
 drivers/mailbox/pcc.c                              | 403 +++++++++++++++++++++
 drivers/remoteproc/omap_remoteproc.c               |  51 +--
 include/linux/mailbox_client.h                     |   3 +
 include/linux/omap-mailbox.h                       |  16 +-
 10 files changed, 701 insertions(+), 188 deletions(-)
 create mode 100644 drivers/mailbox/mailbox.h
 create mode 100644 drivers/mailbox/pcc.c
