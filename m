Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3AUW0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:26:39 -0500
Received: from gimli.pxnet.com ([89.1.7.7]:45315 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3AUW0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:26:37 -0500
X-Greylist: delayed 1730 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 17:26:35 EST
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130121-patch-isdn-00.tilman@imap.cc>
Subject: [PATCH 0/6] ISDN patches for net-next
Date: Mon, 21 Jan 2013 22:57:20 +0100 (CET)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (mail.pxnet.com [89.1.7.7]); Mon, 21 Jan 2013 22:57:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten, David,

here's a series of six patches to the ISDN subsystem. Please consider
for application to net-next. The last one should also go into -stable
and is tagged "CC: stable" accordingly.

Thanks,
Tilman

Tilman Schmidt (6):
      isdn/divert: fix readability damage
      isdn/gigaset: leave DLE mode before hanging up
      isdn/gigaset: beautify interface.c
      isdn/gigaset: beautify common.c
      isdn/gigaset: beautify ev-layer.c
      isdn/gigaset: fix zero size border case in debug dump

 drivers/isdn/divert/divert_init.c |   33 +-
 drivers/isdn/divert/isdn_divert.c |  423 ++++++++++++++++++--------------------
 drivers/isdn/divert/isdn_divert.h |   28 +-
 drivers/isdn/gigaset/capi.c       |    2 
 drivers/isdn/gigaset/common.c     |   31 --
 drivers/isdn/gigaset/ev-layer.c   |  124 +++++------
 drivers/isdn/gigaset/gigaset.h    |    9 
 drivers/isdn/gigaset/interface.c  |   46 +---
 8 files changed, 332 insertions(+), 364 deletions(-)

