Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaCERax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:30:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45930 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaCERav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:30:51 -0500
Message-ID: <53175F07.3050209@oracle.com>
Date: Wed, 05 Mar 2014 10:29:43 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305111006.GT9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140305111006.GT9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 04:10 AM, Peter Zijlstra wrote:
> On Tue, Mar 04, 2014 at 04:51:15PM -0800, Andi Kleen wrote:
>> Anything else?
>
> Proxy execution; its a form of PI that works for arbitrary scheduling
> policies (thus also very much including fair).
>
> With that what you effectively end up with is the lock holder running
> 'boosted' by the runtime of its blocked chain until the entire chain
> runs out of time, at which point preemption doesn't matter anyhow.
>

I assume you are referring to 
http://users.soe.ucsc.edu/~jayhawk/watkins-rtlws09.pdf and/or 
http://www.osadl.org/fileadmin/dam/presentations/RTLWS11/peterz-edf-why-not.pdf 
? I will read through these and see if this can solve the problem.

--
Khalid
