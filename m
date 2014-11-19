Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaKSHHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:07:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbaKSHHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:07:39 -0500
Message-ID: <546C41A5.6090306@redhat.com>
Date: Wed, 19 Nov 2014 15:07:17 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH net] virtio-net: validate features during probe
References: <1416378939-28821-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1416378939-28821-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 02:35 PM, Jason Wang wrote:
> This patch validates feature dependencies during probe and fail the probing
> if a dependency is missed. This fixes the issues of hitting BUG()
> when qemu fails to advertise features correctly. One example is booting
> guest with ctrl_vq=off through qemu.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---

Just notice UFO has been disabled after
3d0ad09412ffe00c9afa201d01effdb6023d09b4 "drivers/net: Disable UFO
through virtio". Will post V2 and drop VIRTIO_NET_F_*_UFO from the
checklist.


