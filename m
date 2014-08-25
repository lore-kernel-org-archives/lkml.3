Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbaHYPAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:00:04 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:63330 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbaHYPAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:00:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140825144710.GA21688@htj.dyndns.org>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140825141220.GA31066@mtj.dyndns.org>
	<CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
	<20140825144710.GA21688@htj.dyndns.org>
Date: Mon, 25 Aug 2014 23:00:00 +0800
Message-ID: <CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q@mail.gmail.com>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, lizefan@huawei.com,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:47 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
>> My point here is that attaching and detaching are a pair of operations.
>
> There is no detaching from a cgroup.  A task is always attached to a
> cgroup whether that's a root or non-root cgroup.

Okey, I should not think it as attaching and detaching. Just treat them as
a move between root and non-root cgroup.

It sounds reasonable to me now.

Thanx.
>
> Thanks.
>
> --
> tejun
