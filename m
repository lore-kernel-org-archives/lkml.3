Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaLNWE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:04:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:46028 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaLNWES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:04:18 -0500
Date: Mon, 15 Dec 2014 00:04:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/6] virtio 1.0: tools update
Message-ID: <1418594542-22623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio test support for virtio 1.0.
Probably a good idea to include for 3.19.

Michael S. Tsirkin (6):
  tools/virtio: more stubs
  tools/virtio: fix vringh test
  tools/virtio: 64 bit features
  tools/virtio: enable -Werror
  tools/virtio: add virtio 1.0 in virtio_test
  tools/virtio: add virtio 1.0 in vringh_test

 tools/virtio/linux/virtio.h            |  1 +
 tools/virtio/linux/virtio_byteorder.h  |  8 ++++++++
 tools/virtio/linux/virtio_config.h     | 25 +++++++++++++++++++++++--
 tools/virtio/uapi/linux/virtio_types.h |  1 +
 tools/virtio/virtio_test.c             | 14 +++++++++++++-
 tools/virtio/vringh_test.c             |  5 ++++-
 tools/virtio/Makefile                  |  2 +-
 7 files changed, 51 insertions(+), 5 deletions(-)
 create mode 100644 tools/virtio/linux/virtio_byteorder.h
 create mode 100644 tools/virtio/uapi/linux/virtio_types.h

-- 
MST

