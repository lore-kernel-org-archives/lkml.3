Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaCCOFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:05:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbaCCOFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:05:15 -0500
Date: Mon, 3 Mar 2014 09:04:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 00/19 V2] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140303140450.GU25953@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <87wqgfawur.fsf@tassilo.jf.intel.com>
 <20140228194233.GK25953@redhat.com>
 <20140228215442.GV22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228215442.GV22728@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:54:42PM +0100, Andi Kleen wrote:
> > It's there. :-)
> > 
> > perf c2c -r -x, report
> > 
> > will spit out raw records in CSV format.
> 
> But most of the cooked data seems not? I saw
> lots of printfs without separator support.
> 
> Sorry I meant data mining the cooked data,
> e.g. plotting it.

Ah. Ok. I will look into that.

Cheers,
Don
