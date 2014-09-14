Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaINPo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:44:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:1128 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbaINPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:44:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,521,1406617200"; 
   d="scan'208";a="572975662"
Date: Sun, 14 Sep 2014 08:44:55 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Vince Weaver <vincent.weaver@maine.edu>, jolsa@redhat.com
Subject: Re: [PATCH] Add some documentation on the perf sysfs ABI interface
Message-ID: <20140914154455.GP5387@tassilo.jf.intel.com>
References: <1410561259-523-1-git-send-email-andi@firstfloor.org>
 <20140914093033.GR346@worktop.programming.kicks-ass.net>
 <20140914153407.GA4064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914153407.GA4064@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 08:34:07AM -0700, Greg KH wrote:
> On Sun, Sep 14, 2014 at 11:30:33AM +0200, Peter Zijlstra wrote:
> > On Fri, Sep 12, 2014 at 03:34:19PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Initial attempt of documenting the perf sysfs interface as
> > > an ABI. I also added some additional pointers hopefully useful
> > > to the users. Comments welcome.
> > 
> > My only worry is that its a little x86 centric and I'm not sure if that
> > is acceptable with the sysfs crowd, Greg?
> 
> Does this document what you have today?  If so, that's fine, and good to
> do.
> 
> Or, is this a proposed interface that is different per architecture in
> subtle non-portable ways?  If so, probably not :)

Each architecture describes its own fields in a generic format that
can be handled by a generic parser.  The generic description is documented.

However I also described the x86 specific attributes.

This is all implemented today.

-Andi
