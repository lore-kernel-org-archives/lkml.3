Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbaHZCPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:15:49 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:50865 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaHZCPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:15:48 -0400
MIME-Version: 1.0
In-Reply-To: <53FBE468.6050805@huawei.com>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140825141220.GA31066@mtj.dyndns.org>
	<CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
	<20140825144710.GA21688@htj.dyndns.org>
	<CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q@mail.gmail.com>
	<53FBE468.6050805@huawei.com>
Date: Tue, 26 Aug 2014 10:15:47 +0800
Message-ID: <CA+qeAOq-=Yzi6tNq_-2O3yYamxXH99fTd=BUFSrbgcvxW5sRSA@mail.gmail.com>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 9:35 AM, Li Zefan <lizefan@huawei.com> wrote:
> On 2014/8/25 23:00, Dongsheng Yang wrote:
>> On Mon, Aug 25, 2014 at 10:47 PM, Tejun Heo <tj@kernel.org> wrote:
>>> On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
>>>> My point here is that attaching and detaching are a pair of operations.
>>>
>>> There is no detaching from a cgroup.  A task is always attached to a
>>> cgroup whether that's a root or non-root cgroup.
>>
>> Okey, I should not think it as attaching and detaching. Just treat them as
>> a move between root and non-root cgroup.
>>
>> It sounds reasonable to me now.
>>
>
> I from time to time have to explain this to other people.

Ha, we usually want to find a detach function when we saw a function
named as cgroup_attach_task().
>
