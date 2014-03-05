Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbaCEVir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:38:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37071 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbaCEVip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:38:45 -0500
Message-ID: <53179915.40408@zytor.com>
Date: Wed, 05 Mar 2014 13:37:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: mingo@kernel.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, seiji.aguchi@hds.com, jolsa@redhat.com,
        vincent.weaver@maine.edu, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, trace: Fix CR2 corruption when tracing
 page faults
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <20140228160526.GD1133@krava.brq.redhat.com> <tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org> <20140305111415.GU9987@twins.programming.kicks-ass.net> <20140305072022.6f69f699@gandalf.local.home> <20140305122535.GA9987@twins.programming.kicks-ass.net> <20140305123635.GP3104@twins.programming.kicks-ass.net> <20140305080018.4be698f7@gandalf.local.home> <20140305130849.GC9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140305130849.GC9987@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 05:08 AM, Peter Zijlstra wrote:
> On Wed, Mar 05, 2014 at 08:00:18AM -0500, Steven Rostedt wrote:
>>>  static void __kprobes
>>
>> Still requires the "noinline" above
> 
> Trim trim trim trim your emails...
> 
> also, you're like 3 version behind.
> 

OK, I have to admit to having lost track of this thread.  Please let me
know when there is anything actionable for me.

	-hpa

