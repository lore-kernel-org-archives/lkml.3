Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab3EBBpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab3EBBpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:45:41 -0400
Date: Thu, 2 May 2013 04:45:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/3] vhost-scsi: file renames
Message-ID: <cover.1367459045.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reorgs the files a bit, renaming tcm_vhost to
vhost_scsi as that's how userspace refers to it.
While at it, cleanup some leftovers from when it was a
staging driver.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


Michael S. Tsirkin (3):
  vhost: src file renames
  tcm_vhost: header split up
  vhost_scsi: module rename

 drivers/vhost/Kconfig                 |  10 ++-
 drivers/vhost/Kconfig.tcm             |   6 --
 drivers/vhost/Makefile                |   3 +-
 drivers/vhost/{tcm_vhost.c => scsi.c} | 115 ++++++++++++++++++++++++++---
 drivers/vhost/tcm_vhost.h             | 131 ----------------------------------
 include/uapi/linux/vhost.h            |  28 ++++++++
 6 files changed, 143 insertions(+), 150 deletions(-)
 delete mode 100644 drivers/vhost/Kconfig.tcm
 rename drivers/vhost/{tcm_vhost.c => scsi.c} (94%)
 delete mode 100644 drivers/vhost/tcm_vhost.h

-- 
MST
