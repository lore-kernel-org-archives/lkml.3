Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3BKN0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:26:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:40788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab3BKN0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:26:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,643,1355126400"; 
   d="scan'208";a="285688506"
Date: Mon, 11 Feb 2013 21:25:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at lib/debugobjects.c:261 debug_print_object()
Message-ID: <20130211132556.GA16137@localhost>
References: <20130208055605.GA7646@localhost>
 <20130211111714.5e6fa4c8dc9c0d99cb1c1de1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211111714.5e6fa4c8dc9c0d99cb1c1de1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:17:14AM +1100, Stephen Rothwell wrote:
> Hi Fengguang,
> 
> On Fri, 8 Feb 2013 13:56:05 +0800 Fengguang Wu <fengguang.wu@intel.com> wrote:
> >
> > I got the below oops and the first bad commit is
> > 
> > commit 457583af4aef89d5252769ea290a2acc89e2361f
> > Author: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date:   Mon Feb 4 18:12:17 2013 +1100
> > 
> >     memory-hotplug: common APIs to support page tables hot-remove fix fix
> >     
> >     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > 
> > I see no direct relationship between the change and oops message,
> > however I tried two bisects and they both converge to the above
> > commit.
> 
> Thanks for the report.
> 
> Did reverting just that commit fix the problem?  Is it still a problem in
> next-20130208?

Stephen, build failed after reverting the commit, however next-20130208
no longer has the problem. So we may probably forget about it.

Thanks,
Fengguang
