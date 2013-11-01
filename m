Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3KAB7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 21:59:53 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53116 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3KAB7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 21:59:51 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-b9-52730b1551be
Date: Fri, 1 Nov 2013 11:00:04 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v9 2/2] Staging: zram: Fix decrement of variable by
 calling bdput()
Message-ID: <20131101020004.GH26080@bbox>
References: <3d7e050910ca994862e7880b4bd3681267681b56.1383220461.git.rashika.kheria@gmail.com>
 <4fdb273ab0b1e7514f119d7e619ac708d2277d34.1383220461.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fdb273ab0b1e7514f119d7e619ac708d2277d34.1383220461.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope subject should be "Fix memory leak by refcount mismatch"

On Thu, Oct 31, 2013 at 05:28:18PM +0530, Rashika Kheria wrote:
> As suggested by Jerome Marchand "The code in reset_store get the block device
> (bdget_disk()) but it does not put it (bdput()) when it's done using it.
> The usage count is therefore incremented but never decremented."
> 
> This patch also puts bdput() for all error cases.
> 
> Cc: stable@vger.kernel.org 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Other than that,
Acked-by: Minchan Kim <minchan@kernel.org>


Rashika, Thanks!

-- 
Kind regards,
Minchan Kim
