Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaBQE4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 23:56:23 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:54689 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaBQE4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 23:56:22 -0500
X-Original-SENDERIP: 10.177.220.194
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 17 Feb 2014 13:56:38 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/4] add compressing abstraction and multi stream
 support
Message-ID: <20140217045638.GA27743@bbox>
References: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

I don't have a time to look at it now
Sorry for that. I will hold the time soonish.

Thanks.

On Wed, Feb 12, 2014 at 10:39:31PM +0300, Sergey Senozhatsky wrote:
> This patchset introduces zcomp compression backend abstraction
> adding ability to support compression algorithms other than LZO;
> support for multi compression streams, making parallel compressions
> possible.
> 
> Diff from v3:
> -- renamed compression backend and working memory structs as requested
>    by Minchan Kim; fixed several issues noted by Minchan Kim.
> 
> Sergey Senozhatsky (4):
>   zram: introduce compressing backend abstraction
>   zram: use zcomp compressing backends
>   zram: support multi compressing buffers
>   zram: document max_comp_streams
> 
>  Documentation/ABI/testing/sysfs-block-zram |   9 +-
>  Documentation/blockdev/zram.txt            |  21 +++-
>  drivers/block/zram/Makefile                |   2 +-
>  drivers/block/zram/zcomp.c                 | 156 +++++++++++++++++++++++++++++
>  drivers/block/zram/zcomp.h                 |  58 +++++++++++
>  drivers/block/zram/zcomp_lzo.c             |  33 ++++++
>  drivers/block/zram/zram_drv.c              | 102 ++++++++++++-------
>  drivers/block/zram/zram_drv.h              |  10 +-
>  8 files changed, 345 insertions(+), 46 deletions(-)
>  create mode 100644 drivers/block/zram/zcomp.c
>  create mode 100644 drivers/block/zram/zcomp.h
>  create mode 100644 drivers/block/zram/zcomp_lzo.c
> 
> -- 
> 1.9.0.rc3.256.g4af3ebd
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
