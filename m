Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3EJIIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:08:37 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52105 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3EJIId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:08:33 -0400
Date: Fri, 10 May 2013 10:08:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 10/13] perf kvm: add live mode
Message-ID: <20130510080829.GA6700@gmail.com>
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
 <1368073909-8825-11-git-send-email-dsahern@gmail.com>
 <20130509085137.GA8813@gmail.com>
 <518BAA92.2030101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518BAA92.2030101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> >2)
> >
> >Another suggestion: it would be nice to allow a "--repeat <n>" option as
> >well, for a limited number of iterations - similar to what the 'top' tool
> >allows:
> >
> >   top -b -d <delay> -n <iterations>
> >
> >--repeat 0 means infinite repeats, --repeat 1 means a single step.
> 
> Missed that option in perf-top. Let me take a look at it.

-n and -b is a regular /usr/bin/top feature, not perf-top feature :-)

perf-top has no such option AFAICS - but it could be added there as well. 
Regular perf-stat has a --repeat option and it's very useful there.

Thanks,

	Ingo
