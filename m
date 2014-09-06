Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaIFJVC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 05:21:02 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49274 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaIFJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 05:20:57 -0400
Message-ID: <540AD288.5050602@gmail.com>
Date: Sat, 06 Sep 2014 11:23:20 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Peter Kieser <peter@kieser.ca>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
References: <20140805043346.GF541@moria.home.lan> <53E10D48.1010700@kernel.dk> <53E7251B.3080305@kieser.ca> <540966BA.9030106@gmail.com> <20140905214532.GA30221@kroah.com>
In-Reply-To: <20140905214532.GA30221@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 11:45 PM, Greg KH wrote:
> On Fri, Sep 05, 2014 at 09:31:06AM +0200, Francis Moreau wrote:
>> On 08/10/2014 09:54 AM, Peter Kieser wrote:
>>>
>>> On 2014-08-05 9:58 AM, Jens Axboe wrote:
>>>> On 08/04/2014 10:33 PM, Kent Overstreet wrote:
>>>>> Hey Jens, here's the pull request for 3.17 - typically late, but lots of tasty
>>>>> fixes in this one :)
>>>> Normally I'd say no, but since it's basically just fixes, I guess we can
>>>> pull it in. But generally, it has to be in my hands a week before this,
>>>> so it can simmer a bit in for-next before going in...
>>>>
>>> Are these fixes going to be backported to 3.10 or other stable releases?
>>>
>>
>> Could you please answer this question ?
>>
>> If you don't want to maintain bcache for stable kernels (I can
>> understand that), can you mark it at least as unstable/experimental
>> stuff since it really is ?
> 
> WTF?
> 
> Just because a maintainer/developer doesn't want to do anything for the
> stable kernel releases does _NOT_ mean the code is
> "unstable/expreimental" at all.
> 
> That's not how stable kernel releases work.  _IF_ a maintainer wants to
> / has the time to, they can mark patches for inclusion in stable kernel
> releases.  Given the huge list of patches that Jens just posted, I doubt
> that those are really something I would ever take for a stable kernel
> release.
> 
> Please read Documentation/stable_kernel_rules.txt for more details
> please.  And don't ask others to do backporting work for you, it's not
> ok, and is something that I have always said is never required, and is
> not going to be.
> 

wow, not sure why I deserve such anger...

Looks like you haven't understood me well and specially I *never* asked
others to do the backporting for me.

Please reread the thread, perhaps peaceful music can help too.

