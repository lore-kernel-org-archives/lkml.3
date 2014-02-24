Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBXDkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:40:47 -0500
Received: from ozlabs.org ([203.10.76.45]:36151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaBXDkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:40:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sridhar Samudrala <sri@us.ibm.com>
Subject: Re: [PATCH net V2] virtio-net: alloc big buffers also when guest can receive UFO
In-Reply-To: <20140221145550.GA4408@redhat.com>
References: <1392959284-11399-1-git-send-email-jasowang@redhat.com> <20140221145550.GA4408@redhat.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 24 Feb 2014 12:00:51 +1030
Message-ID: <87vbw570vo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Fri, Feb 21, 2014 at 01:08:04PM +0800, Jason Wang wrote:
>> We should alloc big buffers also when guest can receive UFO
>> pakcets to let the big packets be fit into guest rx buffer.
>
> s/pakcets/packets/
>
> s/be fit/fit/
>
> otherwise:
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Indeed.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
