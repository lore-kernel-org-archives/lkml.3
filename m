Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaBSM3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:29:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55087 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBSM3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:29:19 -0500
Date: Wed, 19 Feb 2014 13:29:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [sched] BUG: unable to handle kernel NULL pointer dereference at
 00000040
Message-ID: <20140219122916.GL15586@twins.programming.kicks-ass.net>
References: <20140219122132.GB7735@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219122132.GB7735@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 08:21:32PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
> 
> commit 38033c37faab850ed5d33bb675c4de6c66be84d8
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Thu Jan 23 20:32:21 2014 +0100
> Commit:     Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue Feb 11 09:58:10 2014 +0100
> 

Known issue; I'm waiting to Ingo to appear again and merge some patches.
