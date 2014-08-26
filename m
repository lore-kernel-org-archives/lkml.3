Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbaHZBfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:35:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:47348 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbaHZBfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:35:45 -0400
Message-ID: <53FBE468.6050805@huawei.com>
Date: Tue, 26 Aug 2014 09:35:36 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dongsheng Yang <dongsheng081251@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20140825141220.GA31066@mtj.dyndns.org> <CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com> <20140825144710.GA21688@htj.dyndns.org> <CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q@mail.gmail.com>
In-Reply-To: <CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/25 23:00, Dongsheng Yang wrote:
> On Mon, Aug 25, 2014 at 10:47 PM, Tejun Heo <tj@kernel.org> wrote:
>> On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
>>> My point here is that attaching and detaching are a pair of operations.
>>
>> There is no detaching from a cgroup.  A task is always attached to a
>> cgroup whether that's a root or non-root cgroup.
> 
> Okey, I should not think it as attaching and detaching. Just treat them as
> a move between root and non-root cgroup.
> 
> It sounds reasonable to me now.
> 

I from time to time have to explain this to other people.

