Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaDIFpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:45:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60080 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaDIFpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:45:17 -0400
Date: Wed, 9 Apr 2014 07:45:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 4/6 V2] perf, sort:  Add physid sorting based on mmap2
 data
Message-ID: <20140409054503.GW10526@twins.programming.kicks-ass.net>
References: <1395689676-214799-5-git-send-email-dzickus@redhat.com>
 <1395694638-220799-1-git-send-email-dzickus@redhat.com>
 <87lhvft6vm.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhvft6vm.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 02:21:49PM +0900, Namhyung Kim wrote:
> >     create a new 'physid mode' to group all the sorting rules together
> >       (mimics the mem-mode)
> 
> What is 'physid' then?  I guess you meant physical id but it seems
> unique id or unique map id looks like a better fit IMHO.

I suspect this is legacy naming; they used to do this using physical
addresses.
