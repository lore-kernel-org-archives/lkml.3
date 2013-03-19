Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3CSG7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:59:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab3CSG7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:59:16 -0400
Date: Tue, 19 Mar 2013 14:59:07 +0800
From: Asias He <asias@redhat.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, JBottomley@parallels.com,
        pbonzini@redhat.com
Subject: Re: [PATCH V4 0/5] virtio-scsi multiqueue
Message-ID: <20130319065907.GC31573@hj.localdomain>
References: <1362969842-9145-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362969842-9145-1-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:43:57AM +0800, Wanlong Gao wrote:
> This series implements virtio-scsi queue steering, which gives
> performance improvements of up to 50% (measured both with QEMU and
> tcm_vhost backends).
> 
> This version rebased on Rusty's virtio ring rework patches.
> We hope this can go into virtio-next together with the virtio ring
> rework pathes.
> 
> 
> V4: rebase on virtio ring rework patches (rusty's pending-rebases branch)
> 
> V3 and be found http://marc.info/?l=linux-virtualization&m=136067440717154&w=2
> 
> 
> It would probably be easier to get it in via Rusty's tree
> because of the prerequisites.  James, can we get your Acked-by?
> 
> Paolo Bonzini (4):
>   virtio-scsi: redo allocation of target data
>   virtio-scsi: pass struct virtio_scsi to virtqueue completion function
>   virtio-scsi: push vq lock/unlock into virtscsi_vq_done
>   virtio-scsi: introduce multiqueue support
> 
> Wanlong Gao (1):
>   virtio-scsi: reset virtqueue affinity when doing cpu hotplug
> 
>  drivers/scsi/virtio_scsi.c | 364 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 291 insertions(+), 73 deletions(-)
> 
> -- 
> 1.8.2.rc2
> 

Patch 2-5
Reviewed-by: Asias He <asias@redhat.com>

-- 
Asias
