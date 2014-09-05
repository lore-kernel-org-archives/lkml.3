Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaIEWVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:21:46 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39922 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaIEWVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:21:44 -0400
Message-ID: <540A377C.2000901@kernel.dk>
Date: Fri, 05 Sep 2014 16:21:48 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Francis Moreau <francis.moro@gmail.com>
CC: Kent Overstreet <kmo@daterainc.com>, Peter Kieser <peter@kieser.ca>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
References: <20140805043346.GF541@moria.home.lan> <53E10D48.1010700@kernel.dk> <53E7251B.3080305@kieser.ca> <540966BA.9030106@gmail.com> <20140905214532.GA30221@kroah.com>
In-Reply-To: <20140905214532.GA30221@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 03:45 PM, Greg KH wrote:
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

That's not what he is saying at all. The code IS unstable in 3.10. And
the fact that nothing goes to stable for bcache, the situation wasn't
likely to change for 3.10. Nobody is saying "Oh nothing goes to stable,
lets mark it experimental".

> That's not how stable kernel releases work.  _IF_ a maintainer wants to
> / has the time to, they can mark patches for inclusion in stable kernel
> releases.  Given the huge list of patches that Jens just posted, I doubt
> that those are really something I would ever take for a stable kernel
> release.

Actually, all of those are pretty much stable material, since they fix
actual bugs that people hit. Which is the definition of what should go
to stable.

-- 
Jens Axboe

