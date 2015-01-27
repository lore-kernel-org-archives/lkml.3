Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbbA0IHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:07:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48281 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbbA0IHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:07:30 -0500
Date: Tue, 27 Jan 2015 00:07:30 -0800 (PST)
Message-Id: <20150127.000730.1282836791150051952.davem@davemloft.net>
To: tj@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/32] net: use %*pb[l] to print bitmaps including
 cpumasks and nodemasks
From: David Miller <davem@davemloft.net>
In-Reply-To: <1422108218-25398-21-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
	<1422108218-25398-21-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Jan 2015 00:07:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 24 Jan 2015 09:03:26 -0500

> printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
> and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
> respectively which can be used to generate the two printf arguments
> necessary to format the specified cpu/nodemask.
> 
> This patch is dependent on the following two patches.
> 
>  lib/vsprintf: implement bitmap printing through '%*pb[l]'
>  cpumask, nodemask: implement cpumask/nodemask_pr_args()
> 
> Please wait till the forementioned patches are merged to mainline
> before applying to subsystem trees.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Please just apply this directly with those prerequisites, thanks:

Acked-by: David S. Miller <davem@davemloft.net>
