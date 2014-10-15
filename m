Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaJOFqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:46:18 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62888 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaJOFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:46:17 -0400
Message-ID: <543E0A25.80401@gmail.com>
Date: Tue, 14 Oct 2014 22:46:13 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net> <542B4DA3.5080105@gmail.com> <542B519B.6010001@landley.net> <542B5E44.40303@gmail.com> <542B7200.6030902@landley.net> <CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com> <20141001180510.GA28540@cloud> <CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com> <20141014140052.2f114c158ffe6cd953020f1c@linux-foundation.org> <CALCETrXB337oy2BcL3Y-U1CZDqR7TMPxsR9b9R=EatWvvc4zfg@mail.gmail.com>
In-Reply-To: <CALCETrXB337oy2BcL3Y-U1CZDqR7TMPxsR9b9R=EatWvvc4zfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 2:21 PM, Andy Lutomirski wrote:
> On Tue, Oct 14, 2014 at 2:00 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Wed, 1 Oct 2014 11:13:14 -0700 Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>> On Wed, Oct 1, 2014 at 11:05 AM,  <josh@joshtriplett.org> wrote:
>>>> On Tue, Sep 30, 2014 at 09:53:56PM -0700, Andy Lutomirski wrote:
>>>>> I significantly prefer default N.  Scripts that play with init= really
>>>>> don't want the fallback, and I can imagine contexts in which it could
>>>>> be a security problem.
>>>>
>>>> While I certainly would prefer the non-fallback behavior for init as
>>>> well, standard kernel practice has typically been to use "default y" for
>>>> previously built-in features that become configurable.  And I'd
>>>> certainly prefer a compile-time configuration option like this (even
>>>> with default y) over a "strictinit" kernel command-line option.
>>>>
>>>
>>> Fair enough.
>>>
>>> So: "default y" for a release or two, then switch the default?  Having
>>> default y will annoy virtme, though it's not the end of the world.
>>> Virtme is intended to work with more-or-less-normal kernels.
>>>
>>
>> Adding another Kconfig option is tiresome.  What was wrong with strictinit=?
> 
> The consensus seems to be that adding a non-default option to get

      ^^^^^^^^^  I do not think you know what the word consensus means. :-)

I did not agree.

I do agree with Andrew (but with no opinion on whether "strictinit=SOMETHING"
or just "strictinit".

> sensible behavior would be unfortunate.  Also, I don't like
  ^^^^^^^^^^^^^^^^^
  behavior that is useful in some or many contexts

> strictinit=, since backwards-compatible setups will have to do
> init=foo strictinit=foo.  My original proposal was init=foo
> strictinit.
> 
> TBH, my preference would be to make strict mode unconditional.
> http://xkcd.com/1172/
> 
> --Andy
> 

