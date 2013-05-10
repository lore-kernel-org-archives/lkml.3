Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3EJOXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:23:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41941 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab3EJOXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:23:36 -0400
Message-ID: <518D02C8.6080109@oracle.com>
Date: Fri, 10 May 2013 10:23:04 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com> <1368115089-8909-3-git-send-email-sasha.levin@oracle.com> <20130510091816.GC3039@dyad.programming.kicks-ass.net> <20130510101131.GA31152@dyad.programming.kicks-ass.net> <518CF4D5.4070000@oracle.com> <20130510140328.GC304@dyad.programming.kicks-ass.net> <518CFFF5.2060807@oracle.com> <20130510141227.GD304@dyad.programming.kicks-ass.net> <20130510141906.GE304@dyad.programming.kicks-ass.net>
In-Reply-To: <20130510141906.GE304@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 10:19 AM, Peter Zijlstra wrote:
> On Fri, May 10, 2013 at 04:12:27PM +0200, Peter Zijlstra wrote:
>> On Fri, May 10, 2013 at 10:11:01AM -0400, Sasha Levin wrote:
>>> Ah!
>>>
>>> # patch --version
>>> GNU patch 2.7.1
>>
>> I suppose I'd better go find me a fresher patch then! :-)
> 
> *groan* all Debian based distros (with exception of Debian experimental) patch
> is still 2.6.1 -- including the very latestest Ubernuts.
> 
> Means I have to go build from source on all my machines.. not happy.

That's fine, I'll just add a "this file intentionally left blank" in the empty
headers :)


Thanks,
Sasha

