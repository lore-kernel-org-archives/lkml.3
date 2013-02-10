Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3BJLFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:05:12 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62785 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3BJLFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:05:10 -0500
From: sjur.brandeland@stericsson.com
To: Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: sjur@brendeland.net, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ido Yariv <ido@wizery.com>
Subject: [PATCH vringh 0/2] Introduce CAIF Virtio driver
Date: Sun, 10 Feb 2013 12:04:31 +0100
Message-Id: <1360494273-27889-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

This patch-set introduces the CAIF Virtio Link layer driver.

This driver depends on Rusty's new host virtio ring implementation,
so this patch-set is based on the vringh branch in Rusty's git.

Regards,
Sjur

cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Ohad Ben-Cohen <ohad@wizery.com>
cc: David S. Miller <davem@davemloft.net>
cc: Ido Yariv <ido@wizery.com>
cc: Erwan Yvin <erwan.yvin@stericsson.com>

Sjur Brændeland (1):
  remoteproc: Add support for vringh (Host vrings)

Vikram ARV (1):
  caif_virtio: Introduce caif over virtio

 drivers/net/caif/Kconfig               |    8 +
 drivers/net/caif/Makefile              |    3 +
 drivers/net/caif/caif_virtio.c         |  568 ++++++++++++++++++++++++++++++++
 drivers/remoteproc/Kconfig             |    3 +
 drivers/remoteproc/remoteproc_virtio.c |  127 +++++++-
 include/linux/remoteproc.h             |   14 +
 include/linux/virtio_caif.h            |   24 ++
 include/uapi/linux/virtio_ids.h        |    1 +
 8 files changed, 741 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/caif/caif_virtio.c
 create mode 100644 include/linux/virtio_caif.h

-- 
1.7.5.4

