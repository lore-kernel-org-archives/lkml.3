Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab3EFHyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:54:41 -0400
Received: from ozlabs.org ([203.10.76.45]:35182 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3EFHyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:54:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: Add missing 'static' qualifiers
In-Reply-To: <20130505133436.GA6314@redhat.com>
References: <001101ce47a0$a6bfa500$f43eef00$%choi@samsung.com> <20130505133436.GA6314@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 06 May 2013 15:15:34 +0930
Message-ID: <87y5bspsox.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Fri, May 03, 2013 at 10:50:55AM +0900, Jonghwan Choi wrote:
>> Add missing 'static' qualifiers
>> 
>> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied.

Thanks,
Rusty.

>> ---
>>  drivers/block/virtio_blk.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 6472395..5cdf88b 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -20,7 +20,7 @@ module_param(use_bio, bool, S_IRUGO);
>>  static int major;
>>  static DEFINE_IDA(vd_index_ida);
>>  
>> -struct workqueue_struct *virtblk_wq;
>> +static struct workqueue_struct *virtblk_wq;
>>  
>>  struct virtio_blk
>>  {
>> -- 
>> 1.7.9.5
