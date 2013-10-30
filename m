Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3J3CY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:24:26 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43285 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3J3CYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:24:25 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-ae-52706dd7879f
Date: Wed, 30 Oct 2013 11:24:30 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Staging: zram: Fix access of NULL pointer
Message-ID: <20131030022430.GA17013@bbox>
References: <20131019110539.GA25167@gmail.com>
 <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:40:54AM +0530, Rashika Kheria wrote:
> This patch fixes the bug in reset_store caused by accessing NULL pointer.
> 
> The bdev gets its value from bdget_disk() which could fail when memory
> pressure is severe and hence can return NULL because allocation of
> inode in bdget could fail.
> 
> Hence, this patch introduces a check for bdev to prevent reference to a
> NULL pointer in the later part of the code. It also removes unnecessary
> check of bdev for fsync_bdev().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
