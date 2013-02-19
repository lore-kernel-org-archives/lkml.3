Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab3BSJPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:15:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab3BSJPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:15:42 -0500
Message-ID: <512342B8.7060203@redhat.com>
Date: Tue, 19 Feb 2013 10:15:36 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/16] virtio ring rework.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/02/2013 08:56, Rusty Russell ha scritto:
> OK, this is (ab)uses some of Paolo's patches.  The first 7 are
> candidates for this merge window (maybe), the rest I'm not so sure
> about.

Cool, thanks.

> Thanks,
> Rusty.
> 
> Paolo Bonzini (3):
>   scatterlist: introduce sg_unmark_end
>   virtio-blk: reorganize virtblk_add_req
>   virtio-blk: use virtqueue_add_sgs on req path
> 
> Rusty Russell (13):
>   virtio_ring: virtqueue_add_sgs, to add multiple sgs.
>   virtio-blk: use virtqueue_start_buf on bio path

Something wrong with author and commit message in this patch.

I'll send two follow-ups for virtio-scsi, one to be added before patch
7, one after.

Paolo
