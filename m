Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989AbaLOVXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:23:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaLOVXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:23:13 -0500
Date: Mon, 15 Dec 2014 23:23:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/6] virtio 1.0 fixups, tweaks
Message-ID: <1418678575-31755-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a couple of minor compliance issues in new virtio 1.0 code.
Plus, adds a couple of minor cleanups - not bugfixes,
but seem safe enough for 3.19.

Michael S. Tsirkin (6):
  virtio: set VIRTIO_CONFIG_S_FEATURES_OK on restore
  virtio_config: fix virtio_cread_bytes
  virtio_pci_common.h: drop VIRTIO_PCI_NO_LEGACY
  virtio_pci: move probe to common file
  virtio_pci: add VIRTIO_PCI_NO_LEGACY
  virtio: core support for config generation

 drivers/virtio/virtio_pci_common.h |  7 +++----
 include/linux/virtio_config.h      | 29 ++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_pci.h    | 15 ++++++++++-----
 drivers/virtio/virtio.c            | 37 +++++++++++++++++++++++--------------
 drivers/virtio/virtio_pci_common.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/virtio/virtio_pci_legacy.c | 24 ++----------------------
 6 files changed, 99 insertions(+), 47 deletions(-)

-- 
MST

