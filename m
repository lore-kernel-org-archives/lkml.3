Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab3FTTQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:16:15 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4618 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758091Ab3FTTQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:16:14 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <51C354E0.4080906@broadcom.com>
Date: Thu, 20 Jun 2013 21:15:44 +0200
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
 <51C349BD.4030403@broadcom.com>
 <1371753270.18733.99.camel@gandalf.local.home>
 <1371753510.18733.100.camel@gandalf.local.home>
In-Reply-To: <1371753510.18733.100.camel@gandalf.local.home>
X-WSS-ID: 7DDD8C1D1R034531170-18-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/13 20:38, Steven Rostedt wrote:
> On Thu, 2013-06-20 at 14:34 -0400, Steven Rostedt wrote:
>> On Thu, 2013-06-20 at 20:28 +0200, Arend van Spriel wrote:
>>
>>> Reading the whole text with your remark in mind, I guess it does
>>> indicate there are no guarantees depending on the kernel and the list of
>>> operators are what trace-cmd supports. I overlooked/ignored the text
>>> seeing the operators.
>>
>> Exactly, which means that if you over looked the text, so has others.
>> The text
>> should be changed to make it more comprehensible.
>>
>
> Would this change have helped you catch this?

Always difficult to say in retrospect, but it certainly is more clear.

Regards,
Arend

> diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
> index b95e1b4..9ef1e2a 100644
> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -79,10 +79,12 @@ OPTIONS
>       let you use C notation to check if an event should be processed or not.
>
>   ----------------------------------------
> -    ==,>=,<=,>,<,&, |,&&  and ||
> +    ==,>=,<=,>,<,&, ~,&&  and ||
>   ----------------------------------------
>
> -    The above are usually safe to use to compare fields.
> +    Note, not all of the above operators may work with all kernels.
> +    The filter is passed directly to the kernel and is dependent on the
> +    kernel supporting the operators.
>
>   *-v*::
>       This will cause all events specified after it on the command line to not
>
> -- Steve
>
>


