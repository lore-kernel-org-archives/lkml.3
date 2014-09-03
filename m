Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaICJjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:39:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:38925 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaICJjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:39:53 -0400
Date: Wed, 3 Sep 2014 11:39:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] semaphore: Resolve some shadow warnings
Message-ID: <20140903093950.GE4783@worktop.ger.corp.intel.com>
References: <1409228366-7027-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140901120244.GI27892@worktop.ger.corp.intel.com>
 <1409614914.2384.3.camel@jtkirshe-mobl>
 <176C5670-03A7-4003-925D-9C252A7A284F@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176C5670-03A7-4003-925D-9C252A7A284F@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 09:16:23PM +0000, Rustad, Mark D wrote:
> 
> It would, but then it would be unclear as to what units the timeout
> was in. I have no other objection to timeout, I was just trying to
> preserve the meaning in the existing overloaded name. The "n" to me
> suggests a number and, if anything, number of jiffies conveys a more
> precise meaning than simply jiffies did.

Use a comment for the unit. If you look you'll find tons of 'timeout'
variables that measure in jiffies (and others of course).
