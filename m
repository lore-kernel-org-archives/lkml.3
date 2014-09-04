Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaIDR3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:29:47 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:57285 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaIDR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:29:46 -0400
Message-ID: <5408A175.3090400@ahsoftware.de>
Date: Thu, 04 Sep 2014 19:29:25 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>,
        =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
References: <20140812153812.2923046a@monolith.infinux.org> <20140812202129.GA20344@home.goodmis.org> <yw1xr40l2whi.fsf@unicorn.mansr.com> <20140813082756.GB2923@twins.programming.kicks-ass.net> <20140813090013.GA20581@pd.tnic> <53F242D1.4050506@ahsoftware.de> <20140904075453.GK3190@worktop.ger.corp.intel.com> <54083C0F.1040807@ahsoftware.de> <540878D4.7080501@gmail.com>
In-Reply-To: <540878D4.7080501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.09.2014 16:36, schrieb Austin S Hemmelgarn:
> On 2014-09-04 06:16, Alexander Holler wrote:
>>
>> It's a myth that C++ ends up in bigger code than C. At least in my
>> experience. Especially when the latest additions to C++ are in effect
>> (like the move-semantics in C++11 I like quiet a lot and which you get
>> almost for free (by changing nothing) when you use the STL). Thread
>> support is now also standardized (in C++11), quiet nice to use.

> Assuming you are writing in a standalone environment (no standard
> libraries), then yes, your code will usually be about the same size
> (unless you go way overboard with the object-oriented stuff); but the
> runtime is larger in almost all non-standalone environments, and there
> are some cases that code does end up larger in C++.  A lot of 'Clean C'
> (stuff written so that it compiles correctly as C, C++ and Objective C)
> that I have seen seems to end up larger (by about 4-6%) when built as
> C++ (although it usually does much worse as Objective C).

There are always corner cases and I never would use some "Clean C" code 
to compare sizes of C and C++. There is a whole lot of stuff you just 
can't, shouldn't or wouldn't do when using C instead of C++.

And just throwing in some numbers without any explanation about features 
(like exceptions), optimizations and so on you've enabled for the tests 
you used to get those numbers, doesn't work. ;)

I can't really comment on what you mean with "standalone environment" or 
"non-standalone environment", as I don't know what you mean with that. 
But if several programms share e.g. the stuff which is in libstdc++. 
you'll get a lot of size back when compared with C-only programms where 
everyone invents the wheel again and again.

Regards,

Alexander Holler
