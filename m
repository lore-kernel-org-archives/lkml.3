Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaEHLE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:04:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:43058 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaEHLE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:04:28 -0400
Date: Thu, 8 May 2014 13:04:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, xiaofeng_yan2004@126.com
Subject: Re: [PATCH] sched/rt: Fix a comment in struct sched_dl_entity
Message-ID: <20140508110422.GI2844@laptop.programming.kicks-ass.net>
References: <1399545080-17823-1-git-send-email-xiaofeng.yan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399545080-17823-1-git-send-email-xiaofeng.yan@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 10:31:20AM +0000, xiaofeng.yan wrote:
> Change sched_setscheduler2() to sched_setscheduler() in the comments.
> There isn't function sched_setscheduler2() in the main line.
> The previous EDF version defines this function
> before being merged into the main line.
> User should use sched_setscheduler() instead of
> sched_setscheduler2() now.

Nah, you fail.. the interface is now called sched_setattr()
