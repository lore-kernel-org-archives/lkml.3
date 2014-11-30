Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaK3PPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 10:15:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbaK3PNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 10:13:07 -0500
Date: Sun, 30 Nov 2014 17:12:52 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com
Subject: [PATCH v7 43/46] virtio_scsi: move to uapi
Message-ID: <1417359787-10138-44-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417359787-10138-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guests need to use virtio scsi API, so export it to uapi,
nice to e.g. qemu and will help us remember this file
affects ABI.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/{ => uapi}/linux/virtio_scsi.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename include/{ => uapi}/linux/virtio_scsi.h (100%)

diff --git a/include/linux/virtio_scsi.h b/include/uapi/linux/virtio_scsi.h
similarity index 100%
rename from include/linux/virtio_scsi.h
rename to include/uapi/linux/virtio_scsi.h
-- 
MST

