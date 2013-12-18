Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3LRMl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:41:56 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63005 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3LRMly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:41:54 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 0/3] null_blk: documentation, refactor and warning
Date: Wed, 18 Dec 2013 13:41:41 +0100
Message-Id: <1387370504-30853-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I took the liberty to write up some documentation for the blk_null driver.

Additionally, factored the init code paths to use the standard error return
codes. Shuffled some code to aid sharing between the block-layer instantiations.
And at last added a warning when submit_queues parameter is ignored.

Thanks,
Matias

Matias Bjorling (3):
  null_blk: documentation
  null_blk: refactor init and init errors code paths
  null_blk: warning on ignored submit_queues param

 Documentation/block/null_blk.txt | 71 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/null_blk.c         | 66 +++++++++++++++++++++++--------------
 2 files changed, 112 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/block/null_blk.txt

-- 
1.8.3.2

