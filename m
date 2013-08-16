Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3HPOri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:47:38 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:44301 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3HPOre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:47:34 -0400
Date: Fri, 16 Aug 2013 10:47:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, guohanjun@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH] workqueue: Correct/Drop references to gcwq in
 Documentation
Message-ID: <20130816144730.GC2505@htj.dyndns.org>
References: <1376631197-12028-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376631197-12028-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 01:33:17PM +0800, Libin wrote:
> No functional changes. This patch fixes the post gcwq comments in
> Documentation/workqueue.txt.
> 
> Signed-off-by: Libin <huawei.libin@huawei.com>

Thanks a lot for doing this.  Can you please update the unbound pool
part accordingly as described in one of the replies?  Also, it'd be
nice if you bundle these three into a single thread so that the
patches are easier to track.

Thanks!

-- 
tejun
