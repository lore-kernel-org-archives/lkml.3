Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaKDEcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:32:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaKDEce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:32:34 -0500
Date: Tue, 4 Nov 2014 12:32:27 +0800
From: Amos Kong <akong@redhat.com>
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: rusty@rustcorp.com.au, amit.shah@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16 stable PATCH 0/2] virtio-rng: two backports to fix stuck
Message-ID: <20141104043227.GA13409@air.redhat.com>
References: <1412981509-30025-1-git-send-email-akong@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412981509-30025-1-git-send-email-akong@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 06:51:47AM +0800, Amos Kong wrote:
> I received two mails about faile to apply patches to 3.16-stable tree:
> 
> FAILED: patch "[PATCH] virtio-rng: skip reading when we start to remove the device" failed to apply to 3.16-stable tree
> FAILED: patch "[PATCH] virtio-rng: fix stuck of hot-unplugging busy device" failed to apply to 3.16-stable tree
> 
> Amit already backported two patches for 3.16-stable, then cherry-pick
> of my two patches works.
> 
> Thanks.

Ping Greg, thanks.
 
> Amos Kong (2):
>   virtio-rng: fix stuck of hot-unplugging busy device
>   virtio-rng: skip reading when we start to remove the device
> 
>  drivers/char/hw_random/virtio-rng.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
			Amos.
