Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3GQAct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:32:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29373 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3GQAcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:32:43 -0400
Message-ID: <51E5E609.1030202@oracle.com>
Date: Wed, 17 Jul 2013 08:32:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
References: <20130715204135.GH15531@xanatos> <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com> <1373926109.17876.221.camel@gandalf.local.home> <20130715223615.GI15531@xanatos> <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz> <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com> <20130716211235.GG4994@xanatos> <20130716212704.GB9371@thunk.org> <20130716224357.GK4994@xanatos> <1374015299.6458.76.camel@gandalf.local.home> <20130716231217.GL4994@xanatos>
In-Reply-To: <20130716231217.GL4994@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 07:12 AM, Sarah Sharp wrote:

> On Tue, Jul 16, 2013 at 06:54:59PM -0400, Steven Rostedt wrote:
>> On Tue, 2013-07-16 at 15:43 -0700, Sarah Sharp wrote:
>>
>>> Yes, that's true.  Some kernel developers are better at moderating their
>>> comments and tone towards individuals who are "sensitive".  Others
>>> simply don't give a shit.  So we need to figure out how to meet
>>> somewhere in the middle, in order to establish a baseline of civility.
>>
>> I have to ask this because I'm thick, and don't really understand,
>> but ...
>>
>> What problem exactly are we trying to solve here?
> 
> Personal attacks are not cool Steve.  Some people simply don't care if a
> verbal tirade is directed at them.  Others do not want anyone to attack
> them personally, but they're fine with people attacking their code.

+1
I accept someone attaching my code, but it's better if he/she can
point me out why the code is stupid. :)

> 
> Bystanders that don't understand the kernel community structure are
> discouraged from contributing because they don't want to be verbally
> abused, and they really don't want to see either personal attacks or
> intense belittling, demeaning comments about code.

I feel the same way.

> 
> In order to make our community better, we need to figure out where the
> baseline of "good" behavior is.  We need to define what behavior we want
> from both maintainers and patch submitters.  E.g. "No regressions" and
> "don't break userspace" and "no personal attacks".  That needs to be
> written down somewhere, and it isn't.  If it's documented somewhere,
> point me to the file in Documentation.  Hint: it's not there.

Another thing might deviated from the main theme, but I'd like to raise it
here because I would like to see what's the proper way for that.

For instance, people A posted a patch set to the mailing list at first,
people B think that there are some issues in A's implementation, and he
happened to play around the same stuff recently, so he submitted another
patch series.  Finally, people B made it.
(In that period, people A kept silent, maybe because he/she was unhappy) 

This is a actual occurrence I once observed from a subsystem list(my
apologies, I just want to talk this case rather than against somebody),
it seems people A is a new comer(because I can not searched any past
commits of him/her from the git log), people B is definitely a senior guy.

So that's my question, is that a proper collaboration form in kernel
community?  Does it better if people B could give some suggestions to
help A to improve the code, especially if those help would help A stepping
into the kernel development -- maybe it's depend largely on one's opinion. :(


Thanks,
-Jeff
