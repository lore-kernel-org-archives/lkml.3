Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3HGIEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:04:32 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46504 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3HGIEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:04:21 -0400
X-Spam-Score: -100.8
Message-ID: <5201FF45.8000906@asianux.com>
Date: Wed, 07 Aug 2013 16:03:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com> <5201D62B.6080905@asianux.com> <5201E192.7060108@huawei.com> <5201E805.2080008@asianux.com> <5201F10B.7040102@huawei.com>
In-Reply-To: <5201F10B.7040102@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:02 PM, Li Zefan wrote:
>>> To be honest...
>>>
>>> You are too bad in english to do kernel development. You don't seem to
>>> know how to communicate in english...
>>>
>>
>> So I should improve my English, and now I am just trying improving.
>>
>> At least, it is not an excuse to leave upstream kernel development, is
>> it right ?  or do you have additional ideas or suggestions ?
>>
> 
> Two sugguestions.
> 

Firstly, thank you for your suggestions.


> The first one is, if you get a reply from a maintainer (especially a top
> maintainer), try harder to understand/learn from that reply, but don't
> keep asking why and don't keep arguing without much thinking. I think
> what's why sometimes people are annoyed in the discussion with you.
> 

In my opinion, "understand/learn" means:

  learn the proof which the author supplied;
  understand the author's opinion;
  know about what the author wants to do now (especially why he intents to send/reply mail to you).

But "understand/learn" does not mean:

  familiar about the 'professional' details.
  if each related member knows about the 'professional' details, it only need a work flow, not need discussing.

Do you think so too ?


Hmm... for each reply, I think it has 3 requirements:

  1. match the original contents which we want to reply.
  2. say opinion clearly.
  3. provide proof.

I guess your suggestion is for 1st: if we can not understand/learn from
the original contents, of cause, our reply can not match it.

Since discussing is thinking process, and we may get more understanding
during thinking, so it permits to continue reply multiple times (if for
each reply is qualified with the 3 requirements above).


Have you ever seen some of my reply which misunderstand(or not learn
enough) from original contents ?

Maybe you often saw that I continue reply multiple times for a thread,
but I think, each reply matches the 3 requirements above.


> The second one is, better focus on a specific subsystem and try to do some
> real work. It's not bad to start making patches like this one, but it won't
> do you any good in the long term. Don't get addicted in increasing patch
> contribution.

Hmm... I think what you said above is about ways (or method).

For ways, it is meaningless to say which is better or bad, it depends
on one's goal, one's environments, and one's resources.

So, every member need think of it, and find their own suitable ways to
continue providing their contributions to outside with efficiency.


Thanks.
-- 
Chen Gang
