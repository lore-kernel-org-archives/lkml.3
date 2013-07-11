Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab3GKG6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:58:12 -0400
Received: from ozlabs.org ([203.10.76.45]:52464 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab3GKG6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:58:10 -0400
Date: Thu, 11 Jul 2013 16:58:08 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vince@deater.net>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com,
        Stephane Eranian <eranian@google.com>, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130711065807.GA26495@concordia>
References: <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
 <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net>
 <20130709012952.GA7185@concordia>
 <alpine.DEB.2.10.1307082204550.26280@vincent-weaver-1.um.maine.edu>
 <20130709081434.GI25631@dyad.programming.kicks-ass.net>
 <20130710030926.GD7491@concordia>
 <20130710083435.GA24070@gmail.com>
 <alpine.DEB.2.10.1307110039560.26051@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307110039560.26051@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:42:31AM -0400, Vince Weaver wrote:
> On Wed, 10 Jul 2013, Ingo Molnar wrote:
> 
> > Exactly - PMUs enumerated in /sys should be self-identifying, it's a 
> > hardware topology after all ...
> > 
> > Anytime userspace is forced to look into /proc, or into weird places in 
> > /sys it's a FAIL really.
> 
> well on x86 you have to look at /proc/cpuinfo to get the 
> vendor/family/model number.  Should we add some specifier under sys?
> It's probably too late though as all userspace event libs will have
> to look at /proc/cpuinfo anyway to be backwards compatible.

If it's a new library implementing a new feature then no I don't think
it needs to be backward compatible. It's just a choice the library makes
as to what extent it depends on new kernel features.

cheers
