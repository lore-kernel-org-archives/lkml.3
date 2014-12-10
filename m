Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbaLJVtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:49:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaLJVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:49:45 -0500
Date: Wed, 10 Dec 2014 13:49:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET -mm] bitmap, cpumask, nodemask: implement pr_cont
 functions and use di"
Message-Id: <20141210134944.0599597b96026cf2f1597e45@linux-foundation.org>
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014 10:52:42 -0500 Tejun Heo <tj@kernel.org> wrote:

>  0001-bitmap-restructure-bitmap_sn-list-printf.patch
>  0002-bitmap-cpumask-nodemask-implement-pr_cont-variants-o.patch
>  0003-mips-use-cpu-node-mask-pr_cont-and-seq-output-functi.patch
>  0004-powerpc-use-cpu-node-mask-pr_cont-and-seq-output-fun.patch
>  0005-tile-use-cpu-node-mask-pr_cont-and-seq-output-functi.patch
>  0006-x86-use-cpu-node-mask-pr_cont-and-seq-output-functio.patch
>  0007-xtensa-use-cpu-node-mask-pr_cont-and-seq-output-func.patch
>  0008-cpuset-use-cpu-node-mask-pr_cont-and-seq-output-func.patch
>  0009-rcu-use-cpu-node-mask-pr_cont-and-seq-output-functio.patch
>  0010-sched-use-cpu-node-mask-pr_cont-and-seq-output-funct.patch
>  0011-timer-use-cpu-node-mask-pr_cont-and-seq-output-funct.patch
>  0012-percpu-use-cpu-node-mask-pr_cont-and-seq-output-func.patch
> 
> The first two patches implement the pr_cont variants of the formatting
> functions.  The rest convert the existing users to pr_cont and seq
> functions subsystem-by-subsystem.  It'd be the easiest to route all
> through -mm but the conversion patches can go through individual
> subsystem trees afterwards if necessary.

But you're working on other code which will depend on this?  If so
perhaps these should be held in your tree.
