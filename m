Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbaFYPwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:52:44 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45933 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbaFYPwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:52:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH] Fix DRBD regression
Date: Wed, 25 Jun 2014 17:52:37 +0200
Message-Id: <1403711558-27267-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

this patch is intended for 3.16-rc3 (or -rc4). The issue was introduced
with the 3.16 merge window, while adding support for REQ_DISCARD to DRBD.
Please see the commit message for more details.

best regards,
 Phil

Lars Ellenberg (1):
  drbd: fix NULL pointer deref in blk_add_request_payload

 drivers/block/drbd/drbd_receiver.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
1.9.1

