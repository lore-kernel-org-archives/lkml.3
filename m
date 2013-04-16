Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103Ab3DPR3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:29:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56743 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070Ab3DPR3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:29:19 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH 0/2] remoteproc/rpmsg: fix kconfig dependencies for VIRTIO
Date: Tue, 16 Apr 2013 12:24:06 -0500
Message-ID: <1366133046-5369-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This fixes the Kconfig dependency warnings for VIRTIO when remoteproc
and/or rpmsg are enabled. I have intentionally split the change into
two patches, based on testing by enabling STE-MODEM-RPROC and
OMAP_REMOTEPROC separately. The former selects just REMOTEPROC, while
the latter selects both REMOTEPROC & RPMSG. The split should also
enable the patches to come through remoteproc & rpmsg trees respectively.

regards
Suman

Suman Anna (2):
  remoteproc: fix kconfig dependencies for VIRTIO
  rpmsg: fix kconfig dependencies for VIRTIO

 drivers/remoteproc/Kconfig | 1 +
 drivers/rpmsg/Kconfig      | 1 +
 2 files changed, 2 insertions(+)

-- 
1.8.2

