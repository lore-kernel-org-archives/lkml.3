Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3BUG4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:56:09 -0500
Received: from ozlabs.org ([203.10.76.45]:57571 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3BUG4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:56:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/16] virtio ring rework.
In-Reply-To: <512342B8.7060203@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <512342B8.7060203@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 21 Feb 2013 17:00:04 +1030
Message-ID: <877gm2gowj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> Il 19/02/2013 08:56, Rusty Russell ha scritto:
>> OK, this is (ab)uses some of Paolo's patches.  The first 7 are
>> candidates for this merge window (maybe), the rest I'm not so sure
>> about.
>
> Cool, thanks.
>
>> Thanks,
>> Rusty.
>> 
>> Paolo Bonzini (3):
>>   scatterlist: introduce sg_unmark_end
>>   virtio-blk: reorganize virtblk_add_req
>>   virtio-blk: use virtqueue_add_sgs on req path
>> 
>> Rusty Russell (13):
>>   virtio_ring: virtqueue_add_sgs, to add multiple sgs.
>>   virtio-blk: use virtqueue_start_buf on bio path
>
> Something wrong with author and commit message in this patch.

Re: author.  I mangled your patch pretty badly in that case, so I wasn't
sure you wanted the blame.

I have restore your authorship.

Thanks,
Rusty.
