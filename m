Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaJPAbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 20:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaJPAbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 20:31:46 -0400
Message-ID: <543F11EF.4090206@redhat.com>
Date: Thu, 16 Oct 2014 08:31:43 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/3] virtio_net: enabling tx interrupts
References: <1413383116-30977-1-git-send-email-mst@redhat.com>
In-Reply-To: <1413383116-30977-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 10:32 PM, Michael S. Tsirkin wrote:
> RFC patches to enable tx interrupts.
> This is to demonstrate how this can be done without
> core virtio changes, and to make sure I understand
> the new APIs correctly.
>
> Testing TBD: I'm going offline for several days, will only be able to
> test afterwards (unless someone beats me to this).
> So I thought I'd post this early.
>
> Applies on top of patch: "virtio_net: fix use after free"
> that I recently sent.
>
> Changes:
> 	address comments by Jason Wang, use delayed cb everywhere
> 	rebased Jason's patch on top of mine and include it (with some tweaks)
>
> Jason, feel free to either use this, try it out, or take ideas out
> of this patchset and reuse in any other way you see fit.

Sure, will do some tests first.

Thanks
>
> Jason Wang (1):
>   virtio-net: optimize free_old_xmit_skbs stats
>
> Michael S. Tsirkin (2):
>   virtio_net: enable tx interrupt
>   virtio_net: bql
>
>  drivers/net/virtio_net.c | 153 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 111 insertions(+), 42 deletions(-)
>

