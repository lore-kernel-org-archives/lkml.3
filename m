Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaIDSLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:11:42 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56089 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaIDSLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:11:41 -0400
Message-ID: <5408AB3F.4010803@ahsoftware.de>
Date: Thu, 04 Sep 2014 20:11:11 +0200
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
References: <20140812153812.2923046a@monolith.infinux.org> <20140812202129.GA20344@home.goodmis.org> <yw1xr40l2whi.fsf@unicorn.mansr.com> <20140813082756.GB2923@twins.programming.kicks-ass.net> <20140813090013.GA20581@pd.tnic> <53F242D1.4050506@ahsoftware.de> <20140904075453.GK3190@worktop.ger.corp.intel.com> <54083C0F.1040807@ahsoftware.de> <540878D4.7080501@gmail.com> <5408A175.3090400@ahsoftware.de> <5408A84C.1090806@gmail.com>
In-Reply-To: <5408A84C.1090806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.09.2014 19:58, schrieb Austin S Hemmelgarn:
> On 2014-09-04 13:29, Alexander Holler wrote:
>> Am 04.09.2014 16:36, schrieb Austin S Hemmelgarn:
>>> On 2014-09-04 06:16, Alexander Holler wrote:
>>>>
>>>> It's a myth that C++ ends up in bigger code than C. At least in my
>>>> experience. Especially when the latest additions to C++ are in effect
>>>> (like the move-semantics in C++11 I like quiet a lot and which you get
>>>> almost for free (by changing nothing) when you use the STL). Thread
>>>> support is now also standardized (in C++11), quiet nice to use.
>>
>>> Assuming you are writing in a standalone environment (no standard
>>> libraries), then yes, your code will usually be about the same size
>>> (unless you go way overboard with the object-oriented stuff); but the
>>> runtime is larger in almost all non-standalone environments, and there
>>> are some cases that code does end up larger in C++.  A lot of 'Clean C'
>>> (stuff written so that it compiles correctly as C, C++ and Objective C)
>>> that I have seen seems to end up larger (by about 4-6%) when built as
>>> C++ (although it usually does much worse as Objective C).
>>
>> There are always corner cases and I never would use some "Clean C" code
>> to compare sizes of C and C++. There is a whole lot of stuff you just
>> can't, shouldn't or wouldn't do when using C instead of C++.
>>
>> And just throwing in some numbers without any explanation about features
>> (like exceptions), optimizations and so on you've enabled for the tests
>> you used to get those numbers, doesn't work. ;)
>>
>> I can't really comment on what you mean with "standalone environment" or
>> "non-standalone environment", as I don't know what you mean with that.
>> But if several programms share e.g. the stuff which is in libstdc++.
>> you'll get a lot of size back when compared with C-only programms where
>> everyone invents the wheel again and again.
> By standalone environment, I mean no libraries, no libc[++], no external
> dependencies, and in the case of a lot of kernel programming, no
> built-ins.  A OS kernel HAS to be written like that, and it's easier to
> do that in C than C++.  I doubt that you have ever looked at any source
> code for Windows drivers, but Windows is written in C++, and they still
> are just as mind-numbingly insane as some of the poorly maintained,
> vendor originated Linux drivers.

I've seen drivers for Windows and for OS2/2 and DOS and FreeBSD and ...

But throwing the ball back, did you know that all Arduino SW is in C++? ;)

> Not all C is like the Linux kernel, and in fact, if you use Linux,
> probably more than half of your user-space programs were written in C.
> They use dynamic linking just like C++ programs (but often with less
> complex symbol mangling).

This thread isn't about the kernel, but some userspace program which 
does quiet a lot and which wants to do even more. I've just used one 
example I did in the kernel space to explain what I miss when I'm using 
or having to use C instead of C++.

I do understand why the Linux kernel is (still) in C and don't want to 
start a discussion about that.

Regards,

Alexander Holler
