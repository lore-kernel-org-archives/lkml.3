Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3EQPWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:22:53 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:38244 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3EQPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:22:52 -0400
Date: Fri, 17 May 2013 17:22:20 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: keith.busch@intel.com, vishal.l.verma@intel.com,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] NVMe: Fix incompatible pointer type warnings
Message-ID: <20130517152220.GA2807@debian>
References: <1368799780-2871-1-git-send-email-emilgoode@gmail.com>
 <20130517144526.GV6057@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517144526.GV6057@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see, I will resend and include Andrew Morton.

Thanks,

Emil

On Fri, May 17, 2013 at 10:45:26AM -0400, Matthew Wilcox wrote:
> On Fri, May 17, 2013 at 04:09:40PM +0200, Emil Goode wrote:
> > Commit 6a4d55146334 ("block: prep work for batch completion")
> > added a struct batch_complete * as a third argument to bi_end_io.
> > This patch adds the missing third argument to the nvme_bio_pair_endio
> > function.
> 
> That patch isn't in Linus' tree yet, so we can't apply this patch.  It needs
> to go to linux-next.
