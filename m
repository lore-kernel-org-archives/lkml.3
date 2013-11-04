Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3KDLIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:08:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32807 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3KDLIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:08:30 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-5c-52778028e689
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] skd: various fixes/cleanups
Date: Mon, 04 Nov 2013 12:08:18 +0100
Message-id: <1488977.iDESHezIxt@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jQV2NhvIggz9btS16e06yW6y+289m
	cfbXVRaLs01v2C0u75rD5sDqcflsqcf7fVfZPPq2rGL0uHPuA5PH501yAaxRXDYpqTmZZalF
	+nYJXBmf2v8xFezhqXhxdiZ7A2MDVxcjJ4eEgInEoes/2CBsMYkL99YD2VwcQgLTGSW+z//J
	AuG0MElcnTmLGaSKTcBKYmL7KkYQW0RAWGJ/RytQEQcHs0CGRMPdOBBTWMBMYslEV5AKFgFV
	iYt394NV8wpoSiw60sMEYosKeErs2L4SbC8nkP3/9lGwGiEBD4lvhy4zQdQLSvyYfI8FxGYW
	kJfYt38qK4StI7G/dRrbBEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT8
	3E2M4GB+Jr2DcVWDxSFGAQ5GJR5eictlQUKsiWXFlbmHGCU4mJVEeFcUlQcJ8aYkVlalFuXH
	F5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYFzNsfrFm68aH2+em3nkMNOS
	C4yutVWz1rxnVrpySyR1twEnRxan0I2a4853wrk31/86mPnz3IIw9e8zJKYY7uxgtjx6oevz
	0sN9b1a6Lv4u/GhNqlOSdH/IlHV5sjPUQnTcg5qzw1VqQ/oFX20pWvX42l/3Ga5Z7+ILfGP6
	tL82Bmi/vn2oi02JpTgj0VCLuag4EQA1BL/bYgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jens,

Could you please take a look at this patchset? It has been posted
a month ago and there has been no feedback from you.

Today I've noticed that you've recently done some changes in your
for-3.13/drivers branch which seem to duplicate some of my work
(especially commit "skd: rip out bio path") and conflict with my
patchset. :(

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Monday, September 30, 2013 03:25:41 PM Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> Here is a bunch of fixes/cleanups for the new skd driver.
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> Bartlomiej Zolnierkiewicz (14):
>   skd: fix unregister_blkdev() placement
>   skd: fix error paths in skd_init()
>   skd: fix error messages in skd_init()
>   skd: alloc flush slab only if some devices are present
>   skd: register block device only if some devices are present
>   skd: remove SCSI subsystem specific includes
>   skd: use <asm/unaligned.h>
>   skd: remove redundant skdev->pdev assignment from skd_pci_probe()
>   skd: remove SKD_OMIT_FROM_SRC_DIST ifdefs
>   skd: cleanup skd_do_inq_page_da()
>   skd: reorder construct/destruct code
>   skd: reorder skd_flush_cmd_[en,de]queue() code
>   skd: fix formatting in skd_s1120.h
>   skd: remove skd_bio code
> 
>  drivers/block/skd_main.c  | 1015 ++++++++++++---------------------------------
>  drivers/block/skd_s1120.h |  244 +++++------
>  2 files changed, 367 insertions(+), 892 deletions(-)

