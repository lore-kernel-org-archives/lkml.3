Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3JWJJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:09:21 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48159 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3JWJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:09:20 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Oct 2013 05:09:19 EDT
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 0/5] Some DRBD fixes for the 3.13 merge window
Date: Wed, 23 Oct 2013 10:59:14 +0200
Message-Id: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please merge these patches to you for-3.13/drivers branch.
They contain of fixes in random places over the DRBD code

Best,
 Phil


Lars Ellenberg (3):
  drbd: fix NULL pointer deref in module init error path
  drbd: fix decoding of bitmap vli rle for device sizes > 64 TB
  drbd: avoid to shrink max_bio_size due to peer re-configuration

Philipp Reisner (2):
  drbd: Fix an connection drop issue after enabling allow-two-primaries
  drbd: Fix adding of new minors with freshly created meta data

 drivers/block/drbd/drbd_int.h      |    3 ++-
 drivers/block/drbd/drbd_main.c     |   19 ++++++++-------
 drivers/block/drbd/drbd_nl.c       |    6 ++---
 drivers/block/drbd/drbd_receiver.c |   45 +++++++++++++++++-------------------
 drivers/block/drbd/drbd_req.c      |    3 +++
 5 files changed, 38 insertions(+), 38 deletions(-)

-- 
1.7.9.5

