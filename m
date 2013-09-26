Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3IZJ4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:56:43 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48583 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3IZJ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:56:41 -0400
Message-ID: <524404A9.3030602@ahsoftware.de>
Date: Thu, 26 Sep 2013 11:55:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
References: <20130923090100.GE6192@mwanda> <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com> <5241CB44.8080004@ahsoftware.de> <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com> <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com> <52420DF1.7060108@ahsoftware.de> <20130926021130.GD13318@ZenIV.linux.org.uk> <5243A165.2060204@ahsoftware.de> <5243A29C.6080009@ahsoftware.de> <20130926030448.GG13318@ZenIV.linux.org.uk> <5243A993.9070108@ahsoftware.de> <alpine.DEB.2.02.1309260749580.1984@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1309260749580.1984@localhost6.localdomain6>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 07:53, schrieb Julia Lawall:

>> void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
>>                                 struct timespec *wtom, struct timespec
>> *sleep);
>>
>> I like such function names ;) (ok I wouldn't have use those and), but it's
>> hard to press this into 80 characters, especially when the arguments should
>> have some meaning too (e.g. what does wtom stand for?)
>>
>> If you use that somewhere you get
>>
>>         get_xtime_and_monotonic_and_sleep_offset(a, b, c)
>>
>> using silly names and that already is a 58 characters long. So only 22 are
>> left to distribute over 3 variable names. And now think what happens if that
>> wouldn't be a void function.
> 
> Personally, I prefer to use my screen real estate for multiple 80-column 
> windows, so I can see different parts of the code at once.  Anything that 
> goes over 80 columns is very hard to read.
> 
> Perhaps it is a bad example, but I don't even find this very long name 
> very understandable.  Monotonic is an adjective and xtime and sleep are 
> nouns, so I don't understand how it all fits together.  Maybe cramming a

It just was the first long function name I came about. And sometimes a
bit background information helps a lot. So without knowing anything else
about that function, I assume the monotonic time is meant and the author
didn't want to add _time_ to the name because it already is long. In
case of the wtom I would think it's from a second author and I still
have no clue what it might be. Maybe I'm missing some backgroud
information here too and should actually read the description of the
function, if there is any. ;)

> lot of information into a variable name is not always so successful... 
> Actually, I really appreciate comments on functions, that explain the 
> purpose of the function, and the constraints on its usage.

I didn't want do suggest getting rid of (necessary or helpful) comments.

Regards,

Alexander Holler

