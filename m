Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3ISBKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 21:10:18 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:55162 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3ISBKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 21:10:17 -0400
Date: Wed, 18 Sep 2013 21:10:15 -0400 (EDT)
From: Ben Skeggs <bskeggs@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, airlied@redhat.com
Message-ID: <1045388466.15024620.1379553015692.JavaMail.root@redhat.com>
In-Reply-To: <20130917212634.GA31390@redhat.com>
References: <20130917212634.GA31390@redhat.com>
Subject: Re: nouveau: remove pointless assignment
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC30 (Linux)/8.0.3_GA_5664)
Thread-Topic: nouveau: remove pointless assignment
Thread-Index: iKVSOZSX8A5Uuj78ceLh3d+WCrc60Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Dave Jones" <davej@redhat.com>
> To: "Linux Kernel" <linux-kernel@vger.kernel.org>
> Cc: bskeggs@redhat.com, airlied@redhat.com
> Sent: Wednesday, 18 September, 2013 7:26:34 AM
> Subject: nouveau: remove pointless assignment
> 
> self-assignment of a variable doesn't make a lot of sense.
Thanks, search-and-replace left-over, pulled into my tree.

Ben.

> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c
> b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index 755c38d..d0a737c 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -982,7 +982,7 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int
> evict, bool intr,
>  		     bool no_wait_gpu, struct ttm_mem_reg *new_mem)
>  {
>  	struct nouveau_drm *drm = nouveau_bdev(bo->bdev);
> -	struct nouveau_channel *chan = chan = drm->ttm.chan;
> +	struct nouveau_channel *chan = drm->ttm.chan;
>  	struct nouveau_bo *nvbo = nouveau_bo(bo);
>  	struct ttm_mem_reg *old_mem = &bo->mem;
>  	int ret;
> 
