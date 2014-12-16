Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaLPJf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:35:58 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaLPJfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:35:55 -0500
Message-ID: <548FFCF3.9080303@nod.at>
Date: Tue, 16 Dec 2014 10:35:47 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [GIT PULL] Staging driver patches for 3.19-rc1
References: <20141215175535.GA4665@kroah.com> <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com> <20141215183915.GA15554@infradead.org> <20141215184103.GA6761@kroah.com> <20141215185638.GA8036@kroah.com>
In-Reply-To: <20141215185638.GA8036@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.12.2014 um 19:56 schrieb Greg KH:
> On Mon, Dec 15, 2014 at 10:41:03AM -0800, Greg KH wrote:
>> On Mon, Dec 15, 2014 at 10:39:15AM -0800, Christoph Hellwig wrote:
>>> On Mon, Dec 15, 2014 at 07:23:35PM +0100, Richard Weinberger wrote:
>>>> I don't understand this kind of logic.
>>>> a) Binder is considered a piece of shite.
>>>> b) Google is working on a (hopefully sane) replacement.
>>>>
>>>> Why moving it out of staging then? What is the benefit?
>>>
>>> There is none, and Greg didn't even bother addressing the various
>>> comments when this first came up.
>>
>> I thought I did, it was a long thread at the time, and I was on the road
>> for 3 weeks, sorry if I missed something.
>>
>>> So a clear NAK from me on this one.
>>
>> You don't have to maintain it, I do, so why does it concern you?
> 
> Ok, that was a bit snotty on my part, I apologize.
> 
> But really, this is self-contained, doesn't touch any core
> infrastructure, and is really just like any other driver for hardware
> that people don't use.  It shouldn't affect anything elsewhere in the
> kernel, so objecting to it seems odd to me.

Doesn't it use internal stuff from fs/file.c?
Anyway, Linus pulled it.

I'm just a bit astonished that binder finally sneaked into the
core kernel. Hopefully no smart ass will ever decide to make
some userspace component hard depend on it...

Thanks,
//richard
