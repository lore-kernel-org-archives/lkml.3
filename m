Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaKYQo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:44:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaKYQo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:44:26 -0500
Date: Tue, 25 Nov 2014 18:44:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com
Subject: [PATCH v4 39/42] virtio_scsi: move to uapi
Message-ID: <1416933600-21398-40-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guests need to use virtio scsi API, so export it to uapi,
nice to e.g. qemu and will help us remember this file
affects ABI.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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

