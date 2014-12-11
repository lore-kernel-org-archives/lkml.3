Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178AbaLKRBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:01:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964929AbaLKRBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:01:39 -0500
Date: Thu, 11 Dec 2014 19:01:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.or
Subject: [PATCH 0/3] minor virtio 1.0 fixups
Message-ID: <1418317279-13915-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some fixup patches on top of my latest pull request.
Will include in the next pull request.

Michael S. Tsirkin (3):
  virtio: set VIRTIO_CONFIG_S_FEATURES_OK on restore
  virtio_config: fix virtio_cread_bytes
  virtio_pci_common.h: drop VIRTIO_PCI_NO_LEGACY

 drivers/virtio/virtio_pci_common.h |  1 -
 include/linux/virtio_config.h      |  5 ++++-
 drivers/virtio/virtio.c            | 37 +++++++++++++++++++++++--------------
 3 files changed, 27 insertions(+), 16 deletions(-)

-- 
MST

