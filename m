Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3IIORr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:17:47 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:39834 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3IIORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:17:46 -0400
Date: Mon, 9 Sep 2013 10:17:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com, guohanjun@huawei.com
Subject: Re: [PATCH] workqueue: fix comment typo for __queue_work()
Message-ID: <20130909141742.GE25434@htj.dyndns.org>
References: <1378703638-7176-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378703638-7176-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:13:58PM +0800, Libin wrote:
> From: Li Bin <huawei.libin@huawei.com>
> 
> It seems the "dying" should be "draining" here.
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>

Applied to wq/for-3.12-fixes.

Thanks.

-- 
tejun
