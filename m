Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3COJab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:30:31 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:51135 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965Ab3COJa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:30:29 -0400
From: Erwan Yvin <erwan.yvin@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Rusty Russel <rusty@ruscorp.com.au>,
        Ido Yariv <ido@wizery.com>
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>
Subject: [PATCH 0/2] remoteproc : support for host virtio
Date: Fri, 15 Mar 2013 10:29:54 +0100
Message-ID: <1363339796-14591-1-git-send-email-erwan.yvin@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erwan Yvin <erwan.yvin@stericsson.com>

This driver depends on Rusty's new host virtio ring implementation,
so this patch-set is based on the vringh branch in Rusty's git.
with the vringh wrapper patch on top. They do not apply cleanly on top of the
remoteproc virtio config patches from Sjur, but it merges fine.

CAIF will use this new host virtio ring implementation.
Ido, Ohad , Please could you review these patchs ?
            
	    Best regards

Erwan YVIN (1):
  remoteproc: refactor find_vqs to prepare for vringh

Erwan Yvin (1):
  remoteproc: Add support for host virtio rings (vringh)

 drivers/remoteproc/remoteproc_virtio.c |  237 +++++++++++++++++++++++++-------
 include/linux/remoteproc.h             |   22 +++
 2 files changed, 208 insertions(+), 51 deletions(-)

-- 
1.7.9.2

