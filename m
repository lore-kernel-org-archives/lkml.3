Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaESOlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:41:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48339 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaESOlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:41:15 -0400
Message-ID: <537A17F8.6050109@infradead.org>
Date: Mon, 19 May 2014 07:40:56 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Diego Viola <diego.viola@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
References: <20140402144219.4cafbe37@gandalf.local.home>	<20140402221212.GD16570@mguzik.redhat.com>	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>	<87wqf1oi22.fsf@rustcorp.com.au>	<20140502153409.329d3b5b426275e8197251a2@linux-foundation.org>	<871tw9c6kt.fsf@rustcorp.com.au>	<53678ED6.4070502@infradead.org>	<87eh07bu60.fsf@rustcorp.com.au>	<CA+ToGPFQ0Ku0odkAaU4FKDtGq0TK8hJ+HWvJr8J3wJVwYaO2mg@mail.gmail.com> <CA+ToGPF_GnnNhSUZjmbyu=5Nk=i2cTkoWPiykaO4EKJSfvNh-w@mail.gmail.com>
In-Reply-To: <CA+ToGPF_GnnNhSUZjmbyu=5Nk=i2cTkoWPiykaO4EKJSfvNh-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 01:11 AM, Diego Viola wrote:
> I mean "e.g.:" is wrong, it should be e.g. or e.g.,

I don't see that in the wikipedia page.  Are you basing that on
"in this usage it is sometimes followed by a comma, depending on style."?

I don't see a problem with the colon, since the quoted phrase has some
conditions in it, like "sometimes" and "depending".  Colons are often used
to delimit a list or an example, but I'll leave it up to Rusty.


> Sorry to be too nitpicky or annoying about this.
> 
> Diego
> 
> On Mon, May 19, 2014 at 5:06 AM, Diego Viola <diego.viola@gmail.com> wrote:
>> e.g. should be written as e.g. or e.g.,
>>
>> There's no need to add another colon ":" after the one that it's already there.
>>
>> See, http://en.wikipedia.org/wiki/E.g.#e.g.
>>
>> Please fix that.
>>
>> Thanks,
>>
>> Diego
>>
>> On Mon, May 5, 2014 at 9:57 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Randy Dunlap <rdunlap@infradead.org> writes:
>>>> All looks good to me except for 2 instances of "eg" which should be
>>>> "e.g." (just above and about 4 paragraphs below here).
>>>
>>> Thanks, fixed:
>>>
>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>> index 56a4c2d0c741..a42b9dd6b46b 100644
>>> --- a/Documentation/kernel-parameters.txt
>>> +++ b/Documentation/kernel-parameters.txt
>>> @@ -14,7 +14,7 @@ environment, others are passed as command line arguments to init.
>>>  Everything after "--" is passed as an argument to init.
>>>
>>>  Module parameters can be specified in two ways: via the kernel command
>>> -line with a module name prefix, or via modprobe, eg:
>>> +line with a module name prefix, or via modprobe, e.g.:
>>>
>>>         (kernel command line) usbcore.blinkenlights=1
>>>         (modprobe command line) modprobe usbcore blinkenlights=1
>>> @@ -30,7 +30,7 @@ Hyphens (dashes) and underscores are equivalent in parameter names, so
>>>  can also be entered as
>>>         log-buf-len=1M print_fatal_signals=1
>>>
>>> -Double-quotes can be used to protect spaces in values, eg:
>>> +Double-quotes can be used to protect spaces in values, e.g.:
>>>         param="spaces in here"
>>>
>>>  This document may not be entirely up to date and comprehensive. The command
>>> --


-- 
~Randy
