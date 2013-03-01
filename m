Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3CAUpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:45:07 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47451 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3CAUpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:45:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130301203917.GT4503@ZenIV.linux.org.uk>
References: <512B01FA.5020506@huawei.com>
	<512B020D.9040504@huawei.com>
	<20130226022703.GA13837@htj.dyndns.org>
	<512C8D84.7090707@huawei.com>
	<CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
	<512DE4A8.5050303@huawei.com>
	<CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
	<512EFEDF.8080205@huawei.com>
	<CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
	<51304C6D.8050207@huawei.com>
	<20130301203917.GT4503@ZenIV.linux.org.uk>
Date: Fri, 1 Mar 2013 12:45:01 -0800
X-Google-Sender-Auth: 82XiGfxhJOOPApw7VOXA6kLt9MM
Message-ID: <CAOS58YPNAPhWUwNq9G39Airo+TvV2ecXBiNU5s9PFqkL3RbRFg@mail.gmail.com>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

On Fri, Mar 1, 2013 at 12:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > Flexible array members can be statically initialized. If you wanna be
>> > really anal about it, you can do it manually with a wrapping struct
>> > but I don't think that would be necessary.
>> >
>>
>> I didn't know this difference between flexible array and zero-size array.
>> Thanks.
>
> Mind you, initializing flex array member is explicitly invalid per C99;
> it's a GNU extension...

Yeah, that's what I meant by the "anal" part although it seems like
c99 doesn't even allow that. Do we care tho? It seems like a logical
feature which should show up in the standard eventually. Maybe it
could be a problem for clang?

Thanks.

-- 
tejun
