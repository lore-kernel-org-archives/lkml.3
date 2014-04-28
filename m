Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbaD1CBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:01:21 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51430 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbaD1CBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:01:12 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: linux-kernel@vger.kernel.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH v2 0/4] Lustre Klocwork fixes
Date: Sun, 27 Apr 2014 22:00:45 -0400
Message-Id: <1398650449-4587-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just splitting big lnet fixes patch from Klocwork static
analysis tool into smaller bits.
Reworked according to previous comments.

Dmitry Eremin (2):
  staging/lustre/lnet: remove unused variable in
    lnet_destroy_remote_nets_table
  staging/lustre/lnet: fix potential null pointer dereference in
    kiblnd_rejected

Oleg Drokin (2):
  staging/lustre/lnet: Drop useless LASSERT in ksocknal_select_ips
  staging/lustre/lnet: fix potential null pointer dereference

 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c | 8 ++++++--
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c    | 4 ----
 drivers/staging/lustre/lnet/lnet/api-ni.c              | 6 +++---
 drivers/staging/lustre/lnet/lnet/router.c              | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

-- 
1.9.0

