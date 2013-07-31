Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab3GaJtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:49:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39361 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316Ab3GaJtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:49:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 0/5] RFC: DRBD Fixes
Date: Wed, 31 Jul 2013 11:41:10 +0200
Message-Id: <1375263675-18410-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are five independend fixes. Please see the commit messages
for descriptions.

The series is based on v3.11-rc3, and intended for the 3.12 merge
window.

I will post a second series targeted at the 3.12 merge window
in the next days. It will contain only renames (no functional changes)


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

