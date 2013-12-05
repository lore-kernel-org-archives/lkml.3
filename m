Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab3LEOu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:50:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab3LEOu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:50:57 -0500
Date: Thu, 5 Dec 2013 16:54:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] virtio-net: Fix two bugs on unloading the module
Message-ID: <20131205145418.GC23147@redhat.com>
References: <1386254181-17257-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386254181-17257-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 06:36:19PM +0400, Andrey Vagin wrote:
> They can be easy to reproduce, if you try to unload virtio-net
> 
> Andrey Vagin (2):
>   virtio-net: determine type of bufs correctly
>   virtio: delete napi objects from netdev before releasing memory

Thanks a lot for the patches!

>  drivers/net/virtio_net.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> -- 
> 1.8.3.1
