Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaD0VRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:17:51 -0400
Received: from linuxhacker.ru ([217.76.32.60]:49649 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbaD0VRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:17:47 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 0/5] Lustre Klocwork fixes
Date: Sun, 27 Apr 2014 17:17:21 -0400
Message-Id: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just splitting big lnet fixes patch from Klocwork static
analysis tool into smaller bits.

Dmitry Eremin (5):
  staging/lustre/lnet: fix potential null pointer dereference
  staging/lustre/lnet: remove unused variable
  staging/lustre/lnet: fix potential null pointer dereference
  staging/lustre/lnet: fix potential null pointer dereference
  staging/lustre/lnet: fix potential null pointer dereference

 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  8 ++++++--
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c    |  4 ++--
 drivers/staging/lustre/lnet/lnet/api-ni.c              |  6 +++---
 drivers/staging/lustre/lnet/lnet/router.c              |  3 ++-
 drivers/staging/lustre/lnet/selftest/framework.c       | 14 +++++++++++---
 5 files changed, 24 insertions(+), 11 deletions(-)

-- 
1.9.0

