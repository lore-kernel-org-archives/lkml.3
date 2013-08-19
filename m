Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3HSVWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:22:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3HSVWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:22:07 -0400
Date: Mon, 19 Aug 2013 23:22:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: rfc: trivial patches and slow deaths?
In-Reply-To: <1376946644.2016.35.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1308192315000.21654@pobox.suse.cz>
References: <1376944033.2016.13.camel@joe-AO722>  <alpine.LNX.2.00.1308192229360.21654@pobox.suse.cz> <1376946644.2016.35.camel@joe-AO722>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013, Joe Perches wrote:

> This is a 7 line patch that corrects logging defects that has had no 
> reply from you for the last month.
> 
> https://patchwork.kernel.org/patch/2833648/

This hasn't missed any Linus' major release, as it has been submitted post 
3.11 merge, right? (hint, that was Jul 4th).

If this would miss *next* major Linus' release, I would accept your 
complaints. But this is definitely not the case.

Joe, patience is a virtue. Especially when it comes to lower-priority 
stuff.

> I think that's overly long a time frame (any patch series will bitrot) 
> and too opaque for trivial patch submitters to have any idea what's 
> going on.

Again, only large, corss-subsystem series with a lot of maintainers CCed 
are generally delayed.

> Also, if you're concerned that the trivial tree wouldn't merge well in 
> next, 

That's not my concern. My concern is

- avoid work duplication
- avoid git history pollution (again, especially by trivial stuff)
- avoid unecessary stepping on maintainer's toes by something that has 
  such a low importance as trivial.git

Thanks for taking care,

-- 
Jiri Kosina
SUSE Labs
