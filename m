Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936042Ab3DHNqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:46:47 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:49474 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936020Ab3DHNqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:46:45 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.123.88]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 8 Apr 2013 16:46:23 +0300
Message-ID: <CAK=WgbY-M-ZrhAO5rhZazNNK4X706PCYPOS6Ag5pXSsNeM2OGA@mail.gmail.com>
Subject: [GIT PULL] remoteproc fixes for 3.9
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        "Tivy, Robert" <rtivy@ti.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        Suman Anna <s-anna@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
tags/remoteproc-3.9-fixes

for you to fetch changes up to c7426bce5933d16b492a34e42ae77e26fceddff6:

  remoteproc: fix FW_CONFIG typo (2013-04-07 15:11:27 +0300)

----------------------------------------------------------------
4 small remoteproc fixes:
- Suman fixed an issue that crawled in with the move to the new
  idr_alloc interface in 3.9
- Dmitry fixed an STE specific memory leak
- Sjur fixed an error path in the core
- Rob fixed a Kconfig typo

----------------------------------------------------------------
Dmitry Tarnyagin (1):
      remoteproc/ste: fix memory leak on shutdown

Robert Tivy (1):
      remoteproc: fix FW_CONFIG typo

Sjur Brændeland (1):
      remoteproc: fix error path of handle_vdev

Suman Anna (1):
      remoteproc: fix the error check for idr_alloc

 drivers/remoteproc/Kconfig           | 2 +-
 drivers/remoteproc/remoteproc_core.c | 6 ++++--
 drivers/remoteproc/ste_modem_rproc.c | 7 ++++++-
 3 files changed, 11 insertions(+), 4 deletions(-)
