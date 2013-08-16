Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3HPF15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab3HPF14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:27:56 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH 0/6] vhost code cleanup and minor enhancement
Date: Fri, 16 Aug 2013 13:16:24 +0800
Message-Id: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

This series tries to unify and simplify vhost codes especially for zerocopy.

Plase review.

Thanks

Jason Wang (6):
  vhost_net: make vhost_zerocopy_signal_used() returns void
  vhost_net: use vhost_add_used_and_signal_n() in
    vhost_zerocopy_signal_used()
  vhost: switch to use vhost_add_used_n()
  vhost_net: determine whether or not to use zerocopy at one time
  vhost_net: poll vhost queue after marking DMA is done
  vhost_net: remove the max pending check

 drivers/vhost/net.c   |   86 +++++++++++++++++++-----------------------------
 drivers/vhost/vhost.c |   43 +-----------------------
 2 files changed, 36 insertions(+), 93 deletions(-)

