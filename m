Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbbADQCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:02:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbbADQCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:02:24 -0500
Date: Sun, 4 Jan 2015 18:02:13 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: sasha.levin@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/3] virtio_pci: fix DEBUG_KOBJECT_RELEASE
Message-ID: <1420386340-7719-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on Sasha's patch, with some tweaks.


Michael S. Tsirkin (2):
  virtio_pci: device-specific release callback
  virtio_pci: document why we defer kfree

Sasha Levin (1):
  virtio_pci: defer kfree until release callback

 drivers/virtio/virtio_pci_common.h |  1 -
 drivers/virtio/virtio_pci_common.c |  9 ---------
 drivers/virtio/virtio_pci_legacy.c | 12 +++++++++++-
 3 files changed, 11 insertions(+), 11 deletions(-)

-- 
MST

