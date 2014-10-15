Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaJOKbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaJOKba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:31:30 -0400
Message-ID: <543E4CF7.1040405@redhat.com>
Date: Wed, 15 Oct 2014 18:31:19 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH net-next 6/6] virtio-net: enable tx interrupt only
 for the final skb in the chain
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com> <1413357930-45302-7-git-send-email-jasowang@redhat.com> <20141015102251.GE25776@redhat.com>
In-Reply-To: <20141015102251.GE25776@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 06:22 PM, Michael S. Tsirkin wrote:
> On Wed, Oct 15, 2014 at 03:25:30PM +0800, Jason Wang wrote:
>> With the help of xmit_more and virtqueue_enable_cb_avail(), this patch
>> enable tx interrupt only for the final skb in the chain if
>> needed. This will help to mitigate tx interrupts.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> I think you should split xmit_more stuff out.

No much difference but if you prefer I will do this.
