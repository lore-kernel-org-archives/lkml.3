Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3CDJVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:21:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:62346 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab3CDJVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:21:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="294406296"
Date: Mon, 4 Mar 2013 17:21:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [printk A-A deadlock] possible reason: unannotated irqs-on
Message-ID: <20130304092136.GA32204@localhost>
References: <20130304054254.GA21630@localhost>
 <20130304091458.GA17223@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304091458.GA17223@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:14:58AM +0100, Jan Kara wrote:
> On Mon 04-03-13 13:42:54, Wu Fengguang wrote:
> > Greetings,
> > 
> > I got the below oops and the first bad commit is
>   Thanks for report! BTW, I didn't see any oops in the log, just complaints
> from lockdep about a bug in irq handling (which seems to be just a problem
> with lockdep turning on-off in vprintk_emit() which I broke).

You are welcome! And sorry for the misword..

Thanks,
Fengguang
