Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaD1C1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:27:41 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51637 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaD1C0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:26:39 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH v3 0/4] Lustre Klocwork fixes
Date: Sun, 27 Apr 2014 22:25:54 -0400
Message-Id: <1398651958-5103-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just splitting big lnet fixes patch from Klocwork static
analysis tool into smaller bits.
Reworked according to previous comments.
Also, this time with correct CC list.

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

