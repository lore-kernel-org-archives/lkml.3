Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaAOP1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:27:31 -0500
Received: from one.firstfloor.org ([193.170.194.197]:34178 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAOP1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:27:30 -0500
Date: Wed, 15 Jan 2014 16:27:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, namhyung@kernel.org,
        mingo@kernel.org, dsahern@gmail.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/6] perf, tools: Support handling complete branch
 stacks as histograms v3
Message-ID: <20140115152729.GP20765@two.firstfloor.org>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
 <1389661461-18996-3-git-send-email-andi@firstfloor.org>
 <20140115144842.GA17358@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115144842.GA17358@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this option is not added in this patch, I tried:
>   $ perf report --call-graph=fractal,0.5,callee,function,branch

Of course not, it's in the next patch.

But I was not putting the cumbersome long command line into this
example.

If you really feel strongly about it I guess the two patches could be merged,
but seems cleaner separated.

> 
> but as I already said in reply for patch 3, it's not working
> please update the doc in Documentation/perf-report.txt with an example

What kind of example? Full output for a command?

I don't think any other option has that in the man page. It would be
unique.

Having a illustrated `perf tutorial' with examples would probably be a 
good idea, but I'm not sure the man page is the right place for that.

-Andi

