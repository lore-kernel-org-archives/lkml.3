Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaIDSda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:33:30 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:52685 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaIDSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:33:29 -0400
Message-ID: <5408B069.9080708@ahsoftware.de>
Date: Thu, 04 Sep 2014 20:33:13 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Rogelio Serrano <rogelio.serrano@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OT: Open letter to the Linux World
References: <20140812153812.2923046a@monolith.infinux.org>	<20140812202129.GA20344@home.goodmis.org>	<yw1xr40l2whi.fsf@unicorn.mansr.com>	<20140813082756.GB2923@twins.programming.kicks-ass.net>	<20140813090013.GA20581@pd.tnic>	<53F242D1.4050506@ahsoftware.de> <CANszf4jauBAhaTogvSprhhspKywXSu_8xkWh+ETsWMMUDKo0=g@mail.gmail.com>
In-Reply-To: <CANszf4jauBAhaTogvSprhhspKywXSu_8xkWh+ETsWMMUDKo0=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.09.2014 20:27, schrieb Rogelio Serrano:
> On Mon, Aug 18, 2014 at 7:15 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>> Am 13.08.2014 11:00, schrieb Borislav Petkov:
>>
>>> On Wed, Aug 13, 2014 at 10:27:56AM +0200, Peter Zijlstra wrote:
>>>>
>>>> And the thing is; we're all very busy so we tend to take the 'easy'
>>>> way out for things like this; but wholesale switching all my machines
>>>> is indeed painful, and I'm not liking.
>>>
>>>
>>> Right, I think kernel people will gladly jump on a sane solution devoid
>>> of that kids-jerking-off-on-linux-desktop-just-for-the-fun-of-it
>>> situation if someone would present them with one. So, if someone would
>>> come up and do a sane init design without the jerking off, kernel people
>>> would jump on that in a heartbeat. Someone might even start getting
>>> patches from them too. ^^Hint^^ ^^hint^^.
>>>
>>> :-)
>>
>>
>> Hmm, a sane and maintainable solution would use C++ with which people don't
>> have to manually build lists or hashes for every structure like in the
>> kernel (generic programming done right). So you won't find much kernel
>> developers there. ;)
>>
>
> Seriously Dude?
>
> Have you tried it? I was using c++ before during and after the stl was
> standardised
> and the memories of the resulting induced self hair pulling still
> gives me the shivers.
> Try writing a real time kernel with full c++ support. You have to
> provide the entire c++
> runtime in the kernel!
>
> I still do a little c++ programming when i am forced to but its only
> in small pieces.
> Ill go crazy otherwise.

I've started to use C++ when only precompilers (to translate C++ to C) 
were available. That was long before the STL was standardised.

