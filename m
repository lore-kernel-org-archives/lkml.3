Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3CWAQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 20:16:15 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45676
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489Ab3CWAQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 20:16:14 -0400
Date: Fri, 22 Mar 2013 18:15:42 -0600
From: Jens Axboe <axboe@kernel.dk>
To: lars.ellenberg@linbit.com
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH 10/18, update] drbd: prepare to queue write
 requests on a submit worker
Message-ID: <20130323001542.GN1628@kernel.dk>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
 <1363713419-17803-11-git-send-email-philipp.reisner@linbit.com>
 <20130322202224.GJ5231@soda.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322202224.GJ5231@soda.linbit>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22 2013, lars.ellenberg@linbit.com wrote:
> From: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> ---
>  drivers/block/drbd/drbd_int.h  |   13 +++++++++++++
>  drivers/block/drbd/drbd_main.c |   26 +++++++++++++++++++++++++-
>  drivers/block/drbd/drbd_nl.c   |    1 +
>  drivers/block/drbd/drbd_req.c  |   29 +++++++++++++++++++++++++++++
>  4 files changed, 68 insertions(+), 1 deletion(-)
> 
> Updated
> =======
> to apply against current upstream,
> because of 56de210 drbd: convert to idr_alloc()
> affected the context of the last chunk of drbd_main.c; now last two
> chunks: needed to re-add the out_idr_remove_vol cleanup goto.

That's better - updated series and pushed out for testing.

-- 
Jens Axboe

