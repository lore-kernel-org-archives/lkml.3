Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaK0ULr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:11:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaK0ULq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:11:46 -0500
Date: Thu, 27 Nov 2014 22:11:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com
Subject: [PATCH v6 43/46] virtio_scsi: move to uapi
Message-ID: <1417118789-18231-44-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417118789-18231-1-git-send-email-mst@redhat.com>
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

