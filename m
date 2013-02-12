Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab3BLWfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:35:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57558 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab3BLWfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:35:16 -0500
Message-ID: <511AC384.60202@zytor.com>
Date: Tue, 12 Feb 2013 14:34:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [RFC][PATCH v2] tracing/syscalls: Allow archs to ignore tracing
 compat syscalls
References: <1360692087.21867.42.camel@gandalf.local.home>    <511A85E8.7030303@linux.intel.com>   <1360694555.21867.69.camel@gandalf.local.home>   <511A9A64.3040108@linux.intel.com> <511A9DD9.7090805@linux.intel.com>  <1360703939.21867.99.camel@gandalf.local.home>  <511AB525.4050300@linux.intel.com> <1360705324.21867.100.camel@gandalf.local.home>
In-Reply-To: <1360705324.21867.100.camel@gandalf.local.home>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 01:42 PM, Steven Rostedt wrote:
> On Tue, 2013-02-12 at 13:33 -0800, H. Peter Anvin wrote:
>> On 02/12/2013 01:18 PM, Steven Rostedt wrote:
>>> [
>>>   Peter, how about this patch. Instead of showing garbage, just never
>>>   trace compat syscalls, if the arch needs to ignore it.
>>>
>>>   However, users can still use the raw_syscall interface if they need to
>>>   trace them.
>>> ]
>>>
>>
>> I can go for that.  At least it doesn't make the current situation any
>> messier than it currently is, and it prevents incorrect information from
>> being output.
>>
> 
> Great, can I have your Acked-by. Then I'll start testing it and get it
> ready to push for 3.9.
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>


