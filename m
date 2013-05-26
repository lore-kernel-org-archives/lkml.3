Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab3EZBUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 21:20:49 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59327 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab3EZBUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 21:20:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] media: i2c: ths7303 cleanup
Date: Sun, 26 May 2013 03:20:44 +0200
Message-ID: <2855590.yx9zfYZLis@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 May 2013 23:09:32 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Trivial cleanup of the driver.
> 
> Changes for v2:
> 1: Dropped the asynchronous probing and, OF
>    support patches will be handling them independently because of
> dependencies. 2: Arranged the patches logically so that git bisect
>    succeeds.
> 
> Lad, Prabhakar (4):
>   ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
>   media: i2c: ths7303: remove init_enable option from pdata
>   media: i2c: ths7303: remove unnecessary function ths7303_setup()
>   media: i2c: ths7303: make the pdata as a constant pointer
> 
>  arch/arm/mach-davinci/board-dm365-evm.c |    1 -
>  drivers/media/i2c/ths7303.c             |   48 ++++++++--------------------
>  include/media/ths7303.h                 |    2 -
>  3 files changed, 12 insertions(+), 39 deletions(-)

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

