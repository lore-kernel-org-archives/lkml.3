Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaLOQ74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:59:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:40645 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaLOQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:59:53 -0500
Date: Mon, 15 Dec 2014 17:59:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: jun.zhang@intel.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Changcheng Liu <changcheng.liu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched/fair: tiny clearup of -1
Message-ID: <20141215165940.GD29390@twins.programming.kicks-ass.net>
References: <1417759365-28787-1-git-send-email-jun.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417759365-28787-1-git-send-email-jun.zhang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 02:02:45PM +0800, jun.zhang@intel.com wrote:
> From: zhang jun <jun.zhang@intel.com>
> 
> find_idlest_cpu don't return -1, so clearup it.

'clean it up' perhaps?

> Signed-off-by: zhang jun <jun.zhang@intel.com>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Changcheng Liu <changcheng.liu@intel.com>

Invalid SoB chain.
