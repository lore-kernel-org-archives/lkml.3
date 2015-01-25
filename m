Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbbAYQQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:16:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbAYQQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:16:08 -0500
Date: Sun, 25 Jan 2015 21:22:38 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/32] drivers/base: use %*pb[l] to print bitmaps
 including cpumasks and nodemasks
Message-ID: <20150125132238.GA19419@kroah.com>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
 <1422108218-25398-26-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422108218-25398-26-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 09:03:31AM -0500, Tejun Heo wrote:
> printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
> and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
> respectively which can be used to generate the two printf arguments
> necessary to format the specified cpu/nodemask.
> 
> * Line termination only requires one extra space at the end of the
>   buffer.  Use PAGE_SIZE - 1 instead of PAGE_SIZE - 2 when formatting.
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
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
