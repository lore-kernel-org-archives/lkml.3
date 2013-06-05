Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3FEGkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:40:17 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45696 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3FEGkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:40:14 -0400
X-AuditID: 9c93016f-b7ba8ae000004f01-16-51aedd4ce0eb
Date: Wed, 5 Jun 2013 15:40:12 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/10] zram: destroy all devices on error recovery
 path in zram_init()
Message-ID: <20130605064012.GD8732@blaptop>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
 <1370361968-8764-4-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370361968-8764-4-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 12:06:02AM +0800, Jiang Liu wrote:
> On error recovery path of zram_init(), it leaks the zram device object
> causing the failure. So change create_device() to free allocated
> resources on error path.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
