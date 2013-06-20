Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965403Ab3FTS20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:28:26 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3364 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026Ab3FTS2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:28:24 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51C349BD.4030403@broadcom.com>
Date: Thu, 20 Jun 2013 20:28:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 08/12] tracing: Add binary & filter for
 events
References: <20130620033516.003166252@goodmis.org>
 <20130620033639.723900482@goodmis.org> <51C2B8AB.8060709@broadcom.com>
 <1371730487.18733.72.camel@gandalf.local.home>
In-Reply-To: <1371730487.18733.72.camel@gandalf.local.home>
X-WSS-ID: 7DDD98112L836011797-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/13 14:14, Steven Rostedt wrote:
> On Thu, 2013-06-20 at 10:09 +0200, Arend van Spriel wrote:
>> On 06/20/2013 05:35 AM, Steven Rostedt wrote:
>>> By allowing a binary '&' operation, this gives the user the ability to
>>> test a bit.
>>>
>>> Note, a binary '|' is not added, as it doesn't make sense as fields must
>>> be compared to constants (for now), and ORing a constant will always return
>>> true.
>>>
>>> Link:http://lkml.kernel.org/r/1371057385.9844.261.camel@gandalf.local.home
>>>
>>> Suggested-by: Arend van Spriel<arend@broadcom.com>
>>
>> Actually, my attempt was triggered by the trace-cmd manual page:
>>
>> "-f filter
>> Specify a filter for the previous event. This must come after a -e. This
>> will filter what events get recorded based on the content of the event.
>> Filtering is passed to the kernel directly so what filtering is allowed
>> may depend on what version of the kernel you have. Basically, it will
>> let you use C notation to check if an event should be processed or not.
>>
>> ==,>=,<=,>,<,&, |,&&  and ||
>>
>> The above are usually safe to use to compare fields."
>
> Ah thanks. That needs to be updated. Not sure why I wrote all of them.
> Perhaps because the report side handles them and I just assumed the
> kernel did too.

Reading the whole text with your remark in mind, I guess it does 
indicate there are no guarantees depending on the kernel and the list of 
operators are what trace-cmd supports. I overlooked/ignored the text 
seeing the operators.

Regards,
Arend

