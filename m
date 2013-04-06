Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3DFKNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 06:13:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41345 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab3DFKNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 06:13:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,420,1363104000"; 
   d="scan'208";a="7004277"
Message-ID: <515FF581.5040403@cn.fujitsu.com>
Date: Sat, 06 Apr 2013 18:14:25 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, mst@redhat.com, asias@redhat.com,
        venkateshs@google.com, pbonzini@redhat.com,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V7 0/5] virtio-scsi multiqueue
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>  <5153A953.2000101@cn.fujitsu.com> <515E918D.3090307@cn.fujitsu.com> <1365237613.2787.1.camel@dabdike>
In-Reply-To: <1365237613.2787.1.camel@dabdike>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/06 18:12:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/06 18:12:31,
	Serialize complete at 2013/04/06 18:12:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 04:40 PM, James Bottomley wrote:
> On Fri, 2013-04-05 at 16:55 +0800, Wanlong Gao wrote:
>> On 03/28/2013 10:22 AM, Wanlong Gao wrote:
>>> On 03/23/2013 07:28 PM, Wanlong Gao wrote:
>>>> This series implements virtio-scsi queue steering, which gives
>>>> performance improvements of up to 50% (measured both with QEMU and
>>>> tcm_vhost backends).
>>>>
>>>> This version rebased on Rusty's virtio ring rework patches, which
>>>> has already gone into virtio-next today.
>>>> We hope this can go into virtio-next together with the virtio ring
>>>> rework pathes.
>>>>
>>>> V7: respin to fix the patch apply error
>>>>
>>>> V6: rework "redo allocation of target data" (James)
>>>>     fix comments (Venkatesh)
>>>>     rebase to virtio-next
>>>>
>>>> V5: improving the grammar of 1/5 (Paolo)
>>>>     move the dropping of sg_elems to 'virtio-scsi: use virtqueue_add_sgs for command buffers'. (Asias)
>>>>
>>>> V4: rebase on virtio ring rework patches (rusty's pending-rebases branch)
>>>>
>>>> V3 and be found http://marc.info/?l=linux-virtualization&m=136067440717154&w=2
>>>>
>>>>
>>>> It would probably be easier to get it in via Rusty's tree
>>>> because of the prerequisites.  James, can we get your Acked-by?
>>>
>>> James, any thoughts for this version?
>>
>> Ping James....
> 
> Well, I haven't had time to look at anything other than the patch I
> commented on.  I'm happy with your fix, so you can add my acked by to
> that one.  Since it's going through the virtio tree, don't wait for me,
> put it in and I'll make you fix up anything I find later that I'm
> unhappy with.

Got it, thank you James.

Regards,
Wanlong Gao

> 
> James
> 
> 
> 

