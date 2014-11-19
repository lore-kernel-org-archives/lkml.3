Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaKSQSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:18:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaKSQSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:18:37 -0500
Date: Wed, 19 Nov 2014 18:18:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, davem@davemloft.net
Subject: [PATCH 0/3] tun: flag cleanup
Message-ID: <1416413891-29562-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patchset cleans up flag handling in tun.
It logically belongs to net tree, but
I'm basing support for new virtio header on
top of it.  Similar situation will take place
with vhost patches.
Rusty, Dave, what's your take?

Merge this patch through virtio tree?
Merge both this patch and virtio 1.0 patches through vhost tree?

I'm fine with any option.

Please review/ack patches in any case.

Michael S. Tsirkin (3):
  tun: move internal flag defines out of uapi
  tun: reuse IFF_ flags internally
  tun: drop most type defines

 include/uapi/linux/if_tun.h |  14 -----
 drivers/net/tun.c           | 125 ++++++++++++++++----------------------------
 2 files changed, 46 insertions(+), 93 deletions(-)

-- 
MST

