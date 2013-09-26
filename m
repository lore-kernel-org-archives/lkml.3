Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab3IZEXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:23:36 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39350 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3IZEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:23:34 -0400
Message-ID: <5243B657.7070106@ahsoftware.de>
Date: Thu, 26 Sep 2013 06:21:43 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
References: <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com> <5241CB44.8080004@ahsoftware.de> <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com> <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com> <52420DF1.7060108@ahsoftware.de> <20130926021130.GD13318@ZenIV.linux.org.uk> <5243A165.2060204@ahsoftware.de> <5243A29C.6080009@ahsoftware.de> <20130926030448.GG13318@ZenIV.linux.org.uk> <5243A993.9070108@ahsoftware.de> <20130926034828.GJ13318@ZenIV.linux.org.uk>
In-Reply-To: <20130926034828.GJ13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 05:48, schrieb Al Viro:
> On Thu, Sep 26, 2013 at 05:27:15AM +0200, Alexander Holler wrote:
>
>> Oh, personally I don't have any limit there. ;) I like descriptive
>> function and variable names whenever they make sense. And often they
>> make comments uneccessary and therefor prevent errors because those
>> descriptive names are visible whenever the function or variable is
>> used, and comments usually appear only once and get forgotten when
>> scrolled out of the screen.
>>
>> But just take a function like
>>
>> void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
>>                                  struct timespec *wtom, struct
>> timespec *sleep);
>
> Charming...  Now, try to tell one such name from another, when the
> only difference is buried in the middle of long phrase.  And yes,
> I've seen mistakes clearly of that origin.  Made them myself, actually.
>

Nothing is perfect. But the source of the discussion was that I don't 
aggree that limiting the line length makes code more simple.

E.g. In your previous example they could have used some verbose name for 
"flag" without having to cross an obvious non-existing limit. Such the 
author might have seen the "problem" early himself. And I think we all 
do sometimes write silly code, even when we should know it better.

E.g. my first version of something like your example don't have 
necessarily been better as I'm usually first write something down which 
I believe should work, not taking care about anything but functionality. 
Then I take a break and have a second look in such a way like you just 
have exercised it. And I think most people are unable to write perfect 
code right out of their fingers. Of course, I think I got much better in 
avoiding deep nesting right from the beginning, but I'm sure I still 
write sometimes stupid code. And then there are those time constraints 
one just has to withstand, besides the fact that it happens sometimes 
that I just don't won't to have a look at my own code again. (The last 
limit is often reached by endless reviews with comments to remove a 
space here and rename a variable there). Nothing is more annoying than 
rewriting source until it looks like if the commenter has written it.

People do think differently, people see code differently and people 
write code differently and trying to unify that with unnecessary rules 
just annoys almost everyone. I do like it if I can tell who has written 
some code by just looking at it, at least if it is readable and isn't in 
some obvious uglyand hard to read and hard to understand state.

n8,

Alexander Holler

