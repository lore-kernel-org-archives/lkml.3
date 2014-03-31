Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaCaLSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:18:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:49888 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbaCaLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:18:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,764,1389772800"; 
   d="scan'208";a="503450720"
Date: Mon, 31 Mar 2014 19:18:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [do_xor_speed] WARNING: CPU: 0 PID: 1 at init/main.c:708
 do_one_initcall()
Message-ID: <20140331111849.GA12489@localhost>
References: <20140331003825.GA11782@localhost>
 <53391483.9010800@panasas.com>
 <20140331081346.GA5349@localhost>
 <53394A11.6060204@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53394A11.6060204@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 01:57:21PM +0300, Boaz Harrosh wrote:
> On 03/31/2014 11:13 AM, Fengguang Wu wrote:
> > On Mon, Mar 31, 2014 at 10:08:51AM +0300, Boaz Harrosh wrote:
> >> Sorry about that I forgot about the experimental rule, fixed now.
> >>
> >> Is there a way for a white list. With -experimental I need to say
> >> every branch I do not want included is there a way to say only
> >> the branches I do want included?
> > 
> > Yes, sure. You can tell me a list of branch patterns that is suitable
> > for testing and I can blacklist everything else in your tree.
> > 
> > Thanks,
> > Fengguang
> > 
> 
> Thanks Wu, I hate to be trouble. Am I the only one who has this
> problem ? Its that I use this git tree also as a public development
> tree, when need of collaboration.

You are not the only one that needs the manual blacklist/whitelist -
that's why we already have this mechanism. :)

> For now it is good, I'll try to remember when I push new branches

Or better, we are not feeling bothered at all when hit bugs in your
and others' WIP trees - it's an achievement to be able to catch more
bugs, and our test system is designed to do the job efficiently. :)

Thanks,
Fengguang
