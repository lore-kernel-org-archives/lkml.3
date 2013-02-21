Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3BUG4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:56:10 -0500
Received: from ozlabs.org ([203.10.76.45]:44840 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab3BUG4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:56:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: gaowanlong@cn.fujitsu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 10/16] virtio_net: use virtqueue_add_sgs[] for command buffers.
In-Reply-To: <5124A157.5070800@cn.fujitsu.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-11-git-send-email-rusty@rustcorp.com.au> <5124A157.5070800@cn.fujitsu.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 21 Feb 2013 16:57:03 +1030
Message-ID: <87a9qygp1k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
> On 02/19/2013 03:56 PM, Rusty Russell wrote:
>> It's a bit cleaner to hand multiple sgs, rather than one big one.
>> 
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
...
>> +	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
>>  
>> -	ctrl.class = class;
>> -	ctrl.cmd = cmd;
>
> The class and cmd assignment of ctrl header is forgotten?
>
> Thanks,
> Wanlong Gao

Good catch, fixed.

Thanks,
Rusty.
