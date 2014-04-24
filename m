Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaDXMSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:18:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:36855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaDXMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:18:17 -0400
Date: Thu, 24 Apr 2014 14:18:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/3] sched: Initialize newidle balance stats in
 sd_numa_init()
Message-ID: <20140424121813.GT11096@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-3-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398303035-18255-3-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 06:30:34PM -0700, Jason Low wrote:
> Also initialize the per-sd variables for newidle load balancing
> in sd_numa_init().

Vincent actually fixed this 'by accident' in his topology rework, but
I'll queue this for .15 and fix the conflict with his patch, which is
queued for .16.
