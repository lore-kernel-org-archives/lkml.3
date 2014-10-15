Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaJOKnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaJOKnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:43:13 -0400
Date: Wed, 15 Oct 2014 13:46:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH net-next 6/6] virtio-net: enable tx interrupt only
 for the final skb in the chain
Message-ID: <20141015104642.GJ25776@redhat.com>
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com>
 <1413357930-45302-7-git-send-email-jasowang@redhat.com>
 <20141015102251.GE25776@redhat.com>
 <543E4CF7.1040405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543E4CF7.1040405@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 06:31:19PM +0800, Jason Wang wrote:
> On 10/15/2014 06:22 PM, Michael S. Tsirkin wrote:
> > On Wed, Oct 15, 2014 at 03:25:30PM +0800, Jason Wang wrote:
> >> With the help of xmit_more and virtqueue_enable_cb_avail(), this patch
> >> enable tx interrupt only for the final skb in the chain if
> >> needed. This will help to mitigate tx interrupts.
> >>
> >> Cc: Rusty Russell <rusty@rustcorp.com.au>
> >> Cc: Michael S. Tsirkin <mst@redhat.com>
> >> Signed-off-by: Jason Wang <jasowang@redhat.com>
> > I think you should split xmit_more stuff out.
> 
> No much difference but if you prefer I will do this.

In fact I did it exactly like this already :)

-- 
MST
