Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaGHP0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:26:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21848 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHP0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:26:23 -0400
Message-ID: <53BC0D7D.9000207@oracle.com>
Date: Tue, 08 Jul 2014 11:25:49 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mm/sched/net: BUG when running simple code
References: <539A6850.4090408@oracle.com> <20140708145147.GH6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140708145147.GH6758@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 10:51 AM, Peter Zijlstra wrote:
> On Thu, Jun 12, 2014 at 10:56:16PM -0400, Sasha Levin wrote:
>> Hi all,
>> 
>> Okay, I'm really lost. I got the following when fuzzing, and can't really explain what's going on. It seems that we get a "unable to handle kernel paging request" when running rather simple code, and I can't figure out how it would cause it.
>> 
> 
> Are you running on AMD hardware? If so; check out this thread:
> 
> http://marc.info/?i=53B02CEB.7010607@web.de
> 

Unfortunately (luckily?) it's all Intel over here.


Thanks,
Sasha
