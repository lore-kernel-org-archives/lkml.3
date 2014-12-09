Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbaLINxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:53:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040AbaLINxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:53:42 -0500
Date: Tue, 9 Dec 2014 15:53:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com
Subject: [PATCH 0/2] virtio_ccw: minor enhancements
Message-ID: <1418133187-12436-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two enhancements for virtio_ccw, on top of latest 1.0 patchset

Cornelia Huck (1):
  virtio_ccw: finalize_features error handling

Michael S. Tsirkin (1):
  virtio_ccw: future-proof finalize_features

 drivers/s390/kvm/virtio_ccw.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

-- 
MST

