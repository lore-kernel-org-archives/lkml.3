Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab3ICBfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 21:35:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:45316 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab3ICBfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 21:35:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1010,1367996400"; 
   d="scan'208";a="390140106"
Date: Tue, 3 Sep 2013 09:35:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130903013535.GC6855@localhost>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
 <1378156296.1953.117.camel@joe-AO722>
 <20130903003958.GA6855@localhost>
 <1378169274.1953.139.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378169274.1953.139.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 05:47:54PM -0700, Joe Perches wrote:
> On Tue, 2013-09-03 at 08:39 +0800, Fengguang Wu wrote:
> > On Mon, Sep 02, 2013 at 02:11:36PM -0700, Joe Perches wrote:
> []
> > > Fengguang Wu's very useful build robot
> > > sends out emails on build failures.
> > > I think that's great.
> > 
> > Thanks! Yes I'm now running checkpatch these days because some people
> > suggested to me that some of the checkpatch warnings do help catch
> > real bugs.
> 
> Hi Fengguang.
> 
> I see, I don't recall receiving one of these so
> it must be working just fine.

Hi Joe!

Log shows that one of your patch being checked earlier today:

[4 days ago, Joe Perches] perf: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node()

If you have more patches in some git tree that missed the check,
please let me know.

> > However I do try to avoid upsetting people with maybe-subjective
> > warnings. A checkpatch report will only be sent when a small fraction
> > of error types are detected. Comments are very welcome on how to
> > improve this list:
> 
> Your list seems reasonable.
> 
> I might add:
> 
> DOS_LINE_ENDINGS
> MODIFIED_INCLUDE_ASM
> JIFFIES_COMPARISON
> ONE_SEMICOLON

Yeah they all look good to have. Thanks for the suggestions again!

Thanks,
Fengguang
