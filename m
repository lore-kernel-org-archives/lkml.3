Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3IXWLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:11:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:44881 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3IXWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:11:30 -0400
Message-ID: <52420DF1.7060108@ahsoftware.de>
Date: Wed, 25 Sep 2013 00:10:57 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Peter Senna Tschudin <peter.senna@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
References: <20130923090100.GE6192@mwanda> <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com> <5241CB44.8080004@ahsoftware.de> <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com> <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com>
In-Reply-To: <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.09.2013 22:13, schrieb Bjorn Helgaas:
> On Tue, Sep 24, 2013 at 1:29 PM, Peter Senna Tschudin
> <peter.senna@gmail.com> wrote:
>> On Tue, Sep 24, 2013 at 7:26 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>>>> On Mon, Sep 23, 2013 at 3:01 AM, Dan Carpenter <dan.carpenter@oracle.com>
>>>> wrote:
>>>>>
>>>>>                   Long Lines
>>>>>
>>>>> Historically screens were 80 characters wide and it was annoying when
>>>>> code went
>>>>> over the edge.  These days we have larger screens, but we keep the 80
>>>>> character
>>>>> limit because it forces us to write simpler code.
>>>
>>> Sorry, but that just isn't true and never was. Having a line wide limit of
>>> 80 characters while forcing tabs to be 8 characters long limits most code to
>>> just 72 characters. And even less (max 64) inside constructs like if, for or
>>> while.
>>>
>>> The only outcome of that totally silly rule is that variable names will
>>> become shorted to silly acronyms almost nobody does understand make code
>>> unreadable.
>
> In the context of a two-sentence paragraph, Dan's original text is
> pithy and accurate.  A Wikipedia article would deserve more
> elaboration.
>
> Obviously the skill of the programmer is the overwhelming factor, but
> I think restricting the line length does help encourage simpler,
> better-factored code.  It's also part of the whole "it's better to be
> consistent than to be better" thing.  If 95% of the files in Linux use
> 80-character lines and the remainder use longer lines, it's just an
> ongoing hassle for the reader.
>
>>> I always feel like beeing in the IT stone age when programmers thought they
>>> have to use variable names like a, b and c to save storage, memory or to
>>> type less when reading linux kernel code.
>> I was about to disagree because I've never seen variables named a, b
>> or c, but I found that there are at least 2238 variables named a, b or
>> c in linux-next. This is not good.
>
> That is not self-evident.  In many cases, e.g., loop iterators, simple
> names are fine.  Nothing is gained by renaming a loop counter from "a"
> to "array_index."  Simple names for simple things help the reader
> focus on more important aspects of the code.

Sure and I'm the last one who wants that people do have to use anything 
else than i for simple loop counters. And allowing longer lines doesn't 
mean people have to use long names, it allows them use them (if it makes 
sense). That's a big difference.

On the other side it's almost impossible to use verbose variable or 
function names where they would make sense. Not to speak about all the 
ugly splitted lines just to be below that ancient CGA limit.

So such a limit doesn't enforces or helps people to write simpler code. 
It encourages using silly names and confusing line breaks, but in no way 
it helps in writing more simple code. It might make help to keep the 
code base consistent in regard to line lengths and confusing line 
breaks, but that's almost all it does.

Regards,

Alexander Holler
