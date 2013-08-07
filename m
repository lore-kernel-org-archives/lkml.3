Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3HGJOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:14:48 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38419 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab3HGJOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:14:47 -0400
X-Spam-Score: -100.8
Message-ID: <52020FC8.4020504@asianux.com>
Date: Wed, 07 Aug 2013 17:13:44 +0800
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
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com> <5201D62B.6080905@asianux.com> <5201E192.7060108@huawei.com> <5201E805.2080008@asianux.com> <5201F10B.7040102@huawei.com> <5201FF45.8000906@asianux.com> <520208D1.3090102@huawei.com>
In-Reply-To: <520208D1.3090102@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 04:44 PM, Li Zefan wrote:
>>> The first one is, if you get a reply from a maintainer (especially a top
>>> maintainer), try harder to understand/learn from that reply, but don't
>>> keep asking why and don't keep arguing without much thinking. I think
>>> what's why sometimes people are annoyed in the discussion with you.
>>>
>>
>> In my opinion, "understand/learn" means:
>>
>>   learn the proof which the author supplied;
>>   understand the author's opinion;
>>   know about what the author wants to do now (especially why he intents to send/reply mail to you).
>>
>> But "understand/learn" does not mean:
>>
>>   familiar about the 'professional' details.
>>   if each related member knows about the 'professional' details, it only need a work flow, not need discussing.
>>
>> Do you think so too ?
>>
>>
>> Hmm... for each reply, I think it has 3 requirements:
>>
>>   1. match the original contents which we want to reply.
>>   2. say opinion clearly.
>>   3. provide proof.
>>
>> I guess your suggestion is for 1st: if we can not understand/learn from
>> the original contents, of cause, our reply can not match it.
>>
>> Since discussing is thinking process, and we may get more understanding
>> during thinking, so it permits to continue reply multiple times (if for
>> each reply is qualified with the 3 requirements above).
>>
>>
>> Have you ever seen some of my reply which misunderstand(or not learn
>> enough) from original contents ?
>>
>> Maybe you often saw that I continue reply multiple times for a thread,
>> but I think, each reply matches the 3 requirements above.
>>
> 
> You fail to see there's a problem in you and how you frustrate people and
> waste their time...
> 
> For example in this thread:
> 
> https://lkml.org/lkml/2013/7/4/405
> 

For this one, it is other member reply to me, so I think
https://lkml.org/lkml/2013/7/7/117 is more suitable as the last related
thread of my reply.

Isn't this thread qualified with the 3 requirements ?

  1. match the original contents.
  2. say opinion clearly.
  3. with proof.


> and this therad:
> 
> https://lkml.org/lkml/2013/6/20/228
> 

For this one, at least now, I still stick to my opinion: "what he said
is not quite precise".

But since the related member wants stopping discussion, so I stop (in
fact, for the related details contents, he is the last one reply, not
me). :-)


> Please don't argue anymore...
> 

Discussing does not mean arguing.

Since we are both Chinese, one Chinese sentence is "Jun Zi He Er Bu Tong".

excuse me, my English is not quite well, could you (or other Chinese
members) please help to translate it into English ?

Thanks.

> Back to coding and won't reply to this thread...
> 

I can understand, if get none-reply.

Thanks.
-- 
Chen Gang
