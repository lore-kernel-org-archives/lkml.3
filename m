Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab3BTAzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:55:39 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:35974 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758999Ab3BTAzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:55:38 -0500
Message-ID: <51241ED2.5080105@ahsoftware.de>
Date: Wed, 20 Feb 2013 01:54:42 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: What is tip-bot?
References: <512348A1.4000305@ahsoftware.de> <CAFLxGvzuL+w-yfApiLGwWWbB8Om7JUypppoovmSGS2k51Yjgmw@mail.gmail.com> <512355C2.3050009@ahsoftware.de> <512402A7.9020500@infradead.org>
In-Reply-To: <512402A7.9020500@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.02.2013 23:54, schrieb Randy Dunlap:
> On 02/19/2013 02:36 AM, Alexander Holler wrote:
>> Am 19.02.2013 10:54, schrieb richard -rw- weinberger:
>>> On Tue, Feb 19, 2013 at 10:40 AM, Alexander Holler
>>> <holler@ahsoftware.de> wrote:
>>>> Hello,
>>>>
>>>> until now I could successfully suppress my curiosity about those
>>>> tip:foo
>>>> messages, but as the bot (or one of them) has now catched me too, I
>>>> want to
>>>> ask what it is.
>>>>
>>>> Searching for "tip(-)bot" or similiar doesn't reveal some useful info
>>>> (for
>>>> obvious reasons). Could someone give me an URL to source or
>>>> documentation
>>>> about that tool so that I can enlight myself about it's meaning?
>>>
>>> AFAIK tip-bot is a set of shell scripts used by _T_glx, _I_ngo and
>>> _P_eter. :)
>>>
>>
>> So messages from tip-bot are just acknowledgments (like those from Greg)
>> that a patch has found it's way into one of the trees, with the
>> difference that tip-bot sends those acknowledgments to lkml too, whereas
>> Greg's scripts send them only to involved parties and not the lkml?
>
> Yes, that is my understanding of it.
>

Thanks a lot for clarification.

In the meanwhile I've found an article at lwn about the kernel 
development process which lists many of the git repositories used by 
various maintainers. And that list includes tip. ;)

So the reason for my ignorance was that I didn't know that tip is 
actually the name of a git repository used by the x86 maintainers.

Regards,

Alexander
