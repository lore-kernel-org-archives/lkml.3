Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3EQPIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:08:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24340 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3EQPIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:08:44 -0400
Date: Fri, 17 May 2013 18:08:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Emil Goode <emilgoode@gmail.com>, keith.busch@intel.com,
        vishal.l.verma@intel.com, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] NVMe: Fix incompatible pointer type warnings
Message-ID: <20130517150800.GP1360@mwanda>
References: <1368799780-2871-1-git-send-email-emilgoode@gmail.com>
 <20130517144526.GV6057@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517144526.GV6057@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:45:26AM -0400, Matthew Wilcox wrote:
> On Fri, May 17, 2013 at 04:09:40PM +0200, Emil Goode wrote:
> > Commit 6a4d55146334 ("block: prep work for batch completion")
> > added a struct batch_complete * as a third argument to bi_end_io.
> > This patch adds the missing third argument to the nvme_bio_pair_endio
> > function.
> 
> That patch isn't in Linus' tree yet, so we can't apply this patch.  It needs
> to go to linux-next.

The 6a4d55146334 ("block: prep work for batch completion") is from
the -mm tree.

regards,
dan carpenter

