Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3KEQHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:07:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33810 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3KEQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:07:54 -0500
Message-ID: <527917C5.7050402@kernel.dk>
Date: Tue, 05 Nov 2013 09:07:33 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/11] skd: various fixes/cleanups
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 04:36 AM, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> Here is a bunch of fixes/cleanups for the new skd driver.
> 
> Reference to v1:
> 	https://lkml.org/lkml/2013/9/30/279
> 
> Changes since v1:
> - synced against for-3.13/drivers branch (commit 76c4a6f) of block tree
> - dropped no longer needed patch #4 ("skd: alloc flush slab only if some
>   devices are present"), #12 ("skd: reorder skd_flush_cmd_[en,de]queue()
>   code") and #14 ("skd: remove skd_bio code")
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> Bartlomiej Zolnierkiewicz (11):
>   skd: fix unregister_blkdev() placement
>   skd: fix error paths in skd_init()
>   skd: fix error messages in skd_init()
>   skd: register block device only if some devices are present
>   skd: remove SCSI subsystem specific includes
>   skd: use <asm/unaligned.h>
>   skd: remove redundant skdev->pdev assignment from skd_pci_probe()
>   skd: remove SKD_OMIT_FROM_SRC_DIST ifdefs
>   skd: cleanup skd_do_inq_page_da()
>   skd: reorder construct/destruct code
>   skd: fix formatting in skd_s1120.h

Thanks Bart, applied.

-- 
Jens Axboe

