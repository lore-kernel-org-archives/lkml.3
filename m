Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3AKJK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:10:29 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:61342 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3AKJKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:10:17 -0500
Message-ID: <50EFD6F4.7030903@linaro.org>
Date: Fri, 11 Jan 2013 10:10:12 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: please cleanup the cpuidle tree
References: <20130108092751.4bd60a67280e284369553c18@canb.auug.org.au> <50EB5636.4080705@linaro.org> <20130108102227.19d4102cb1ddf516ad4082d1@canb.auug.org.au> <20130111115608.dffec30f37e42a8f15a3f117@canb.auug.org.au>
In-Reply-To: <20130111115608.dffec30f37e42a8f15a3f117@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 01:56 AM, Stephen Rothwell wrote:
> Hi Daniel,
> 
> On Tue, 8 Jan 2013 10:22:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> On Tue, 08 Jan 2013 00:11:50 +0100 Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>>>
>>> On 01/07/2013 11:27 PM, Stephen Rothwell wrote:
>>>>
>>>> All the commits in the cpuidle tree have been included upstream before
>>>> v3.6-rc1.  They were rewritten before being merged upstream and so are
>>>> now causing merge conflicts in linux-next.  Could you please reset the
>>>> head of your tree
>>>> (git://git.linaro.org/people/dlezcano/cpuidle-next.git#cpuidle-next) to
>>>> be somewhere in the tree that yours is merged into (pm or Linus').
>>>
>>> Sure. I believe it is done now.
>>
>> Yep, thanks.
> 
> Unfortunately, you reset your tree to be a version of the pm tree that has
> now been rebased :-(  This is now causing more conflicts in linux-next.
> Maybe you should reset your tree to be the same as one of Linus' -rc
> releases for now.

Ok, done.

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

