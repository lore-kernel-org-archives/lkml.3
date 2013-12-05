Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab3LEOkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:40:47 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:9659 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab3LEOkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:40:45 -0500
From: Andrey Vagin <avagin@openvz.org>
To: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 0/2] virtio-net: Fix two bugs on unloading the module
Date: Thu,  5 Dec 2013 18:36:19 +0400
Message-Id: <1386254181-17257-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They can be easy to reproduce, if you try to unload virtio-net

Andrey Vagin (2):
  virtio-net: determine type of bufs correctly
  virtio: delete napi objects from netdev before releasing memory

 drivers/net/virtio_net.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
-- 
1.8.3.1

