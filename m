Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3C1SXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:23:09 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44312 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3C1SXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:23:08 -0400
Date: Thu, 28 Mar 2013 11:23:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hanjun Guo <guohanjun@huawei.com>,
        jiang.liu@huawei.com, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 1/2] mm: remove CONFIG_HOTPLUG ifdefs
Message-ID: <20130328182305.GA12903@kroah.com>
References: <1364437418-9144-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364437418-9144-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 10:23:38AM +0800, Yijing Wang wrote:
> CONFIG_HOTPLUG is going away as an option, cleanup CONFIG_HOTPLUG
> ifdefs in mm files.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Bill Pemberton <wfp5p@virginia.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

