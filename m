Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab3ISP0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:26:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:40860 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3ISP0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:26:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,937,1371106800"; 
   d="scan'208";a="398170158"
Date: Thu, 19 Sep 2013 23:26:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] regulator: fix fatal kernel-doc error
Message-ID: <20130919152626.GB7925@localhost>
References: <5237AB72.5020806@infradead.org>
 <20130917103238.GM21013@sirena.org.uk>
 <52388CC4.7040101@infradead.org>
 <20130917192355.GK21013@sirena.org.uk>
 <20130917233328.GC11390@localhost>
 <20130919140131.GB21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919140131.GB21013@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 03:01:31PM +0100, Mark Brown wrote:
> On Wed, Sep 18, 2013 at 07:33:28AM +0800, Fengguang Wu wrote:
> > On Tue, Sep 17, 2013 at 08:23:55PM +0100, Mark Brown wrote:
> 
> > > Could these checks be added to Fengguang's tester?  If nobody's looking
> > > at the output (I've never found the processed output useful myself) or
> > > running the tool then it's a bit worrying...
> 
> > Yes, I'm running "make htmldocs" checks and send out all new warnings:
> 
> > Does that sound enough?
> 
> I'd expect it to be but then it seems like the issue that Randy found
> wasn't picked up...  not sure if there's some other build that would
> cover it or something.

Yes.. it was missed because the script used to only grep for
"Warning(.*)" patterns and ignored the "Error(.*)" ones. Fixed
since last email.

Thanks,
Fengguang
