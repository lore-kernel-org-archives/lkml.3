Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3GQODc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:03:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:65067 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3GQODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:03:30 -0400
Message-ID: <51E6A39E.3020109@windriver.com>
Date: Wed, 17 Jul 2013 10:01:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, David Lang <david@lang.hm>,
        <ksummit-2013-discuss@lists.linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
References: <20130715204135.GH15531@xanatos> <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com> <1373926109.17876.221.camel@gandalf.local.home> <20130715223615.GI15531@xanatos> <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz> <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com> <20130716211235.GG4994@xanatos> <20130716212704.GB9371@thunk.org> <20130716224357.GK4994@xanatos> <1374015299.6458.76.camel@gandalf.local.home> <20130716231217.GL4994@xanatos> <1374017917.6458.103.camel@gandalf.local.home>
In-Reply-To: <1374017917.6458.103.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-07-16 07:38 PM, Steven Rostedt wrote:
> On Tue, 2013-07-16 at 16:12 -0700, Sarah Sharp wrote:
> 

[...]

> 
>>   We need to define what behavior we want
>> from both maintainers and patch submitters.  E.g. "No regressions" and
>> "don't break userspace"
> 
> Yes, those do need to be documented.

Actually, they are already documented. See "Regressions" section in the
file Documentation/development-process/4.Coding

Paul.
--

> 
> 
>>  and "no personal attacks".
> 
> I actually disagree with this. What I would say this instead: "try to
> keep it technical and focus on the code. If you are upset at someone,
> think twice before hitting send. But if you really think this is the
> only way to deal with the situation, then that's your call, and you get
> to deal with the consequences."
> 
> I don't think changing peoples behavior is going to work. It wont. You
> don't want to change who you are, others don't want to change who they
> are. Deal with it. But what we can do is just try to educate people on
> what policies are needed to be a maintainer and code submitter (there is
> documentation already on some of this), and then point it to people. If
> people continue to ignore those after being shown, then yes, personal
> attacks are then in order.
> 
> 
>>   That needs to be
>> written down somewhere, and it isn't.  If it's documented somewhere,
>> point me to the file in Documentation.  Hint: it's not there.
> 
> Well, SubmittingPatches is there, but we should have a MaintainerRules
> or something.
> 
>>
>> That is the problem.
> 
> We can always use better documentation.
> 
> -- Steve
> 
> 
> _______________________________________________
> Ksummit-2013-discuss mailing list
> Ksummit-2013-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-2013-discuss
> 
> 
