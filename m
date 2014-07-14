Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaGNBpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 21:45:01 -0400
Received: from one.firstfloor.org ([193.170.194.197]:56380 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaGNBo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 21:44:58 -0400
Date: Mon, 14 Jul 2014 03:44:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/11] perf, tools, test: Add test case for alias and
 JSON parsing
Message-ID: <20140714014455.GA18735@two.firstfloor.org>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
 <1405123165-22666-11-git-send-email-andi@firstfloor.org>
 <20140712231005.GB29028@krava.redhat.com>
 <20140712234959.GY18735@two.firstfloor.org>
 <20140713200945.GA1800@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140713200945.GA1800@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 10:09:45PM +0200, Jiri Olsa wrote:
> On Sun, Jul 13, 2014 at 01:49:59AM +0200, Andi Kleen wrote:
> > > missing the tests/aliases.o file
> > > 
> > >   AR       libperf.a
> > > ar: tests/aliases.o: No such file or directory
> > 
> > Fixed here (and in git)
> 
> got it, would you be ok with following change?
> using pr_* instead of fprintf calls..

Yes that's fine. Thanks.
-Andi
