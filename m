Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3EQOpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:45:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:34884 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab3EQOps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:45:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,692,1363158000"; 
   d="scan'208";a="304019652"
Date: Fri, 17 May 2013 10:45:26 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: keith.busch@intel.com, vishal.l.verma@intel.com,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] NVMe: Fix incompatible pointer type warnings
Message-ID: <20130517144526.GV6057@linux.intel.com>
References: <1368799780-2871-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368799780-2871-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 04:09:40PM +0200, Emil Goode wrote:
> Commit 6a4d55146334 ("block: prep work for batch completion")
> added a struct batch_complete * as a third argument to bi_end_io.
> This patch adds the missing third argument to the nvme_bio_pair_endio
> function.

That patch isn't in Linus' tree yet, so we can't apply this patch.  It needs
to go to linux-next.
