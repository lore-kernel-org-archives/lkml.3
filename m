Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaCGF4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:56:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaCGF4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:56:23 -0500
Date: Fri, 7 Mar 2014 13:56:36 +0800
From: Fam Zheng <famz@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-scsi: Change sense buffer size to 252
Message-ID: <20140307055636.GA2514@T430.nay.redhat.com>
References: <1394095660-15075-1-git-send-email-famz@redhat.com>
 <53184962.3080100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53184962.3080100@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03/06 11:09, Paolo Bonzini wrote:
> Il 06/03/2014 09:47, Fam Zheng ha scritto:
> >According to SPC-4, section 4.5.2.1, 252 is the limit of sense data. So
> >increase the value.
> >
> >Signed-off-by: Fam Zheng <famz@redhat.com>
> >---
> > include/linux/virtio_scsi.h | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
> >index 4195b97..a437f7f 100644
> >--- a/include/linux/virtio_scsi.h
> >+++ b/include/linux/virtio_scsi.h
> >@@ -28,7 +28,7 @@
> > #define _LINUX_VIRTIO_SCSI_H
> >
> > #define VIRTIO_SCSI_CDB_SIZE   32
> >-#define VIRTIO_SCSI_SENSE_SIZE 96
> >+#define VIRTIO_SCSI_SENSE_SIZE 252
> >
> > /* SCSI command request, followed by data-out */
> > struct virtio_scsi_cmd_req {
> >
> 
> Hi Fam, how did you test this?
> 

I only tested the basic functionality of virtio-scsi. I'm doing more testing on
this and your fix on QEMU side now.

Thanks,
Fam
