Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaEGVyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:54:37 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:41500 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaEGVyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:54:32 -0400
Date: Thu, 8 May 2014 01:54:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140507215430.GH8607@moon>
References: <20140506202307.GA1458@moon>
 <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu>
 <20140506214630.GB1458@moon>
 <alpine.DEB.2.10.1405071244570.6340@vincent-weaver-1.umelst.maine.edu>
 <20140507164902.GD1444@moon>
 <20140507165811.GG1444@moon>
 <alpine.DEB.2.10.1405071305010.6340@vincent-weaver-1.umelst.maine.edu>
 <20140507182410.GA8607@moon>
 <alpine.DEB.2.10.1405071713590.7020@vincent-weaver-1.umelst.maine.edu>
 <20140507215144.GG8607@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507215144.GG8607@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 01:51:44AM +0400, Cyrill Gorcunov wrote:
> 
> > When fuzzing on the p4 *other* things do happen.
> > 	* at least two warnings pop up almost instantly
> > 	* eventually the machine will crash in an endless NMI storm
> > 	* also I managed to get the machine wedged with an unkillable
> > 	  process, sort of like the known problem PeterZ has.
> > 
> > The NMI issue is probably the only one that is p4 related, and I do get 
> > the NMI warnings on other machines too, it's just the p4 is the only one 
> > where it brings down the machine.
> 
> Vince, could you please provde more details on that? Is it possible
> to somehow log which events were used by perf?

There were a bug in p4 pmu Don (CC'ed) fixed not that long ago but I fear
not all corner cases might be covered yet.
