Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaJJWvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaJJWvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:51:53 -0400
From: Amos Kong <akong@redhat.com>
To: stable@vger.kernel.org
Cc: rusty@rustcorp.com.au, amit.shah@redhat.com, gregkh@linuxfoundation.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [3.16 stable PATCH 0/2] virtio-rng: two backports to fix stuck
Date: Sat, 11 Oct 2014 06:51:47 +0800
Message-Id: <1412981509-30025-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I received two mails about faile to apply patches to 3.16-stable tree:

FAILED: patch "[PATCH] virtio-rng: skip reading when we start to remove the device" failed to apply to 3.16-stable tree
FAILED: patch "[PATCH] virtio-rng: fix stuck of hot-unplugging busy device" failed to apply to 3.16-stable tree

Amit already backported two patches for 3.16-stable, then cherry-pick
of my two patches works.

Thanks.

Amos Kong (2):
  virtio-rng: fix stuck of hot-unplugging busy device
  virtio-rng: skip reading when we start to remove the device

 drivers/char/hw_random/virtio-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
1.9.3

