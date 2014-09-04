Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaIDTSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:18:13 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41937 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaIDTSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:18:11 -0400
MIME-Version: 1.0
X-Originating-IP: [12.227.248.5]
In-Reply-To: <5408B069.9080708@ahsoftware.de>
References: <20140812153812.2923046a@monolith.infinux.org>
	<20140812202129.GA20344@home.goodmis.org>
	<yw1xr40l2whi.fsf@unicorn.mansr.com>
	<20140813082756.GB2923@twins.programming.kicks-ass.net>
	<20140813090013.GA20581@pd.tnic>
	<53F242D1.4050506@ahsoftware.de>
	<CANszf4jauBAhaTogvSprhhspKywXSu_8xkWh+ETsWMMUDKo0=g@mail.gmail.com>
	<5408B069.9080708@ahsoftware.de>
Date: Thu, 4 Sep 2014 14:18:08 -0500
Message-ID: <CAOS_Y6RAiwY=Zh4g6Ei4UYm3FMybwf+bSo_CwqQhaMsaJh10uw@mail.gmail.com>
Subject: Re: OT: Open letter to the Linux World
From: Rob Landley <rob@landley.net>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Rogelio Serrano <rogelio.serrano@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 1:33 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>>> Hmm, a sane and maintainable solution would use C++ with which people
>>> don't
>>> have to manually build lists or hashes for every structure like in the
>>> kernel (generic programming done right). So you won't find much kernel
>>> developers there. ;)
>>>
>>
>> Seriously Dude?
>>
>> Have you tried it? I was using c++ before during and after the stl was
>> standardised
>> and the memories of the resulting induced self hair pulling still
>> gives me the shivers.
>> Try writing a real time kernel with full c++ support. You have to
>> provide the entire c++
>> runtime in the kernel!
>>
>> I still do a little c++ programming when i am forced to but its only
>> in small pieces.
>> Ill go crazy otherwise.
>
>
> I've started to use C++ when only precompilers (to translate C++ to C) were
> available. That was long before the STL was standardised.

What's actually wrong with C++ at a language design level.

Short version:

http://lwn.net/Articles/504751/

Long version (parts 1, 2, 3):

http://landley.net/notes-2011.html#16-03-2011
http://landley.net/notes-2011.html#19-03-2011
http://landley.net/notes-2011.html#20-03-2011

Seriously, saying C++ is a good language because it contains the whole
of C is like saying a mud pie is a good beverage because it contains
an entire glass of water.

Do you honestly think this is the first time this topic has come up?

http://harmful.cat-v.org/software/c++/linus

Rob
