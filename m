Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161335Ab3DGCB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 22:01:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161173Ab3DGCB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 22:01:56 -0400
Date: Sun, 7 Apr 2013 10:01:40 +0800
From: Asias He <asias@redhat.com>
To: rusty@rustcorp.com.au
Cc: gaowanlong@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        venkateshs@google.com, pbonzini@redhat.com,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V7 0/5] virtio-scsi multiqueue
Message-ID: <20130407020140.GA6409@hj.localdomain>
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <5153A953.2000101@cn.fujitsu.com>
 <515E918D.3090307@cn.fujitsu.com>
 <1365237613.2787.1.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365237613.2787.1.camel@dabdike>
X-Operating-System: Linux hj.localdomain 3.8.4-202.fc18.x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 09:40:13AM +0100, James Bottomley wrote:
> On Fri, 2013-04-05 at 16:55 +0800, Wanlong Gao wrote:
> > On 03/28/2013 10:22 AM, Wanlong Gao wrote:
> > > On 03/23/2013 07:28 PM, Wanlong Gao wrote:
> > >> This series implements virtio-scsi queue steering, which gives
> > >> performance improvements of up to 50% (measured both with QEMU and
> > >> tcm_vhost backends).
> > >>
> > >> This version rebased on Rusty's virtio ring rework patches, which
> > >> has already gone into virtio-next today.
> > >> We hope this can go into virtio-next together with the virtio ring
> > >> rework pathes.
> > >>
> > >> V7: respin to fix the patch apply error
> > >>
> > >> V6: rework "redo allocation of target data" (James)
> > >>     fix comments (Venkatesh)
> > >>     rebase to virtio-next
> > >>
> > >> V5: improving the grammar of 1/5 (Paolo)
> > >>     move the dropping of sg_elems to 'virtio-scsi: use virtqueue_add_sgs for command buffers'. (Asias)
> > >>
> > >> V4: rebase on virtio ring rework patches (rusty's pending-rebases branch)
> > >>
> > >> V3 and be found http://marc.info/?l=linux-virtualization&m=136067440717154&w=2
> > >>
> > >>
> > >> It would probably be easier to get it in via Rusty's tree
> > >> because of the prerequisites.  James, can we get your Acked-by?
> > > 
> > > James, any thoughts for this version?
> > 
> > Ping James....
> 
> Well, I haven't had time to look at anything other than the patch I
> commented on.  I'm happy with your fix, so you can add my acked by to
> that one.  Since it's going through the virtio tree, don't wait for me,
> put it in and I'll make you fix up anything I find later that I'm
> unhappy with.

So, Rusty, could you pick this up in your virtio-next tree?

> James
> 
> 

-- 
Asias
