Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3HPOoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:44:14 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:37489 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3HPOoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:44:07 -0400
Date: Fri, 16 Aug 2013 10:44:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, guohanjun@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH] workqueue: Comment correction in file header
Message-ID: <20130816144403.GA2505@htj.dyndns.org>
References: <1376631164-11836-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376631164-11836-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Libin.

On Fri, Aug 16, 2013 at 01:32:44PM +0800, Libin wrote:
>   * This is the generic async execution mechanism.  Work items as are
>   * executed in process context.  The worker pool is shared and
> - * automatically managed.  There is one worker pool for each CPU and
> - * one extra for works which are better served by workers which are
> + * automatically managed.  There are two worker pools for each CPU(one
> + * for normal work items and the other for high priority ones) and
> + * two extra for works which are better served by workers which are

For unbound workqueues, the number of backing pools is dynamic.
Unbound workqueue can be assigned custom attributes using
apply_workqueue_attrs() and workqueue will automatically create
backing worker pools matching the attributes.

Can you please update this and the doc update patch accordingly?

Thanks.

-- 
tejun
