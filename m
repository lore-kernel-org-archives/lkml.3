Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbbAFKo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:44:57 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbbAFKo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:44:56 -0500
Date: Tue, 6 Jan 2015 11:44:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH] sched/core: remove check of p->sched_class
Message-ID: <20150106104439.GP29390@twins.programming.kicks-ass.net>
References: <1419835303-28958-1-git-send-email-yaodongdong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419835303-28958-1-git-send-email-yaodongdong@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 02:41:43PM +0800, Yao Dongdong wrote:
> Search all usage of p->sched_class in sched/core.c, no one check it
> before use, so it seems that every task must belong to one sched_class.
> 

Thanks
