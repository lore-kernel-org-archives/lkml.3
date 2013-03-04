Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3CDDDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:03:49 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:24067 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3CDDDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:03:47 -0500
Message-ID: <51340ECD.1030905@huawei.com>
Date: Mon, 4 Mar 2013 11:02:37 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
References: <512B01FA.5020506@huawei.com> <512B020D.9040504@huawei.com> <20130226022703.GA13837@htj.dyndns.org> <512C8D84.7090707@huawei.com> <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com> <512DE4A8.5050303@huawei.com> <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com> <512EFEDF.8080205@huawei.com> <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com> <51304C6D.8050207@huawei.com> <20130301203917.GT4503@ZenIV.linux.org.uk> <CAOS58YPNAPhWUwNq9G39Airo+TvV2ecXBiNU5s9PFqkL3RbRFg@mail.gmail.com>
In-Reply-To: <CAOS58YPNAPhWUwNq9G39Airo+TvV2ecXBiNU5s9PFqkL3RbRFg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/2 4:45, Tejun Heo wrote:
> Hello, Al.
> 
> On Fri, Mar 1, 2013 at 12:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>>> Flexible array members can be statically initialized. If you wanna be
>>>> really anal about it, you can do it manually with a wrapping struct
>>>> but I don't think that would be necessary.
>>>>
>>>
>>> I didn't know this difference between flexible array and zero-size array.
>>> Thanks.
>>
>> Mind you, initializing flex array member is explicitly invalid per C99;
>> it's a GNU extension...
> 
> Yeah, that's what I meant by the "anal" part although it seems like
> c99 doesn't even allow that. Do we care tho? It seems like a logical
> feature which should show up in the standard eventually. Maybe it
> could be a problem for clang?
> 

Do we have a decision now? Please pick v4 if this GNU extension can't be used
in kernel code, otherwise v5.

