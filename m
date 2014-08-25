Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbaHYOqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:07 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:54975 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbaHYOqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140825141220.GA31066@mtj.dyndns.org>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140825141220.GA31066@mtj.dyndns.org>
Date: Mon, 25 Aug 2014 22:46:03 +0800
Message-ID: <CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, lizefan@huawei.com,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tj.

On Mon, Aug 25, 2014 at 10:12 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Aug 25, 2014 at 07:32:10PM +0800, Dongsheng Yang wrote:
>> Currently, the only method to detach a task from a cgroup is moving
>> it to others. It looks not natrual to me.
>
> Ummm... how is this different from moving it to the root cgroup?
> "just because" usually isn't a good enough rationale.
>

Thanx for your reply :).

My point here is that attaching and detaching are a pair of operations.
And the things involved in these operations should be a process
and a cgroup. But currently, when we want to detach a process from
a cgroup (A), we have to attach it to another cgroup (B). I think it is not
easy to understand. People would say: "Why I want to detach a process
from A, I have to care about another cgroup."

So I created this patch here wanting to make these operations more easy to
understand. And make attaching and detaching to be antonymous in action.

I think maybe we can use it in the Cgroup V2 which is in developing. :)

That's all my reason for this patch. But you could think it makes no sense.
It's okey to me.

Thanx

> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
