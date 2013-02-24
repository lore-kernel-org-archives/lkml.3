Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab3BXWSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:18:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408Ab3BXWSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:18:48 -0500
Date: Mon, 25 Feb 2013 00:18:58 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH dontapply 0/2] tools/virtio updates for API testing
Message-ID: <cover.1361743821.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patchset to update tools/virtio with
changes in 3.8, as well as the proposed API extension.

Useful to see whether the extra level of indirection
adds measureable overhead.

I will upstream at least patch 1 soon.

Michael S. Tsirkin (2):
  tools/virtio: fix build for 3.8
  tools/virtio: update for the new virtio API

 drivers/vhost/test.c        |  4 +++-
 tools/virtio/Makefile       |  2 +-
 tools/virtio/linux/virtio.h | 52 ++++++++++++++++++++++++++++++++++++++-------
 tools/virtio/virtio_test.c  |  3 ++-
 4 files changed, 50 insertions(+), 11 deletions(-)

-- 
MST
