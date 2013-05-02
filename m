Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab3EBBpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab3EBBpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:45:47 -0400
Date: Thu, 2 May 2013 04:45:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/3] vhost: src file renames
Message-ID: <dd82beeeb355468cc1ec180142a2085d6477482a.1367459046.git.mst@redhat.com>
References: <cover.1367459045.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1367459045.git.mst@redhat.com>
X-Mutt-Fcc: =sent
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tcm_vhost.c -> scsi.c

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/Makefile                | 1 +
 drivers/vhost/{tcm_vhost.c => scsi.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/vhost/{tcm_vhost.c => scsi.c} (100%)

diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index a27b053..6ea9cec 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_VHOST_NET) += vhost_net.o
 vhost_net-y := vhost.o net.o
 
 obj-$(CONFIG_TCM_VHOST) += tcm_vhost.o
+tcm_vhost-y := scsi.o
diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/scsi.c
similarity index 100%
rename from drivers/vhost/tcm_vhost.c
rename to drivers/vhost/scsi.c
-- 
MST

