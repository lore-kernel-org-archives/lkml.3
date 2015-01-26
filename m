Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbbAZFjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:39:54 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:58908 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbbAZFjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:39:52 -0500
Message-ID: <54C5D2CE.5030402@huawei.com>
Date: Mon, 26 Jan 2015 13:38:22 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -tip/urgent  0/2]kprobes bugfixes around optprobe
References: <20150123064217.30731.49156.stgit@localhost.localdomain>
In-Reply-To: <20150123064217.30731.49156.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.129]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Is there any problem on these patches? I'm unable to find them in upstream kernel
and -tip repository.

Thank you.

On 2015/1/23 14:42, Masami Hiramatsu wrote:
> Hi Ingo,
> 
> Here are two patches for fixing bugs in kprobes, related to
> optprobe and enable/disable kprobe knob.
> 
> These are reported and fixed by Wang Nan.
> https://lkml.org/lkml/2015/1/5/270
> https://lkml.org/lkml/2015/1/19/680
> 
> Thank you,
> 
> 
> ---
> 
> Wang Nan (2):
>       [BUGFIX]kprobes: set kprobes_all_disarmed earlier to enable re-optimization.
>       [BUGFIX]kprobes: makes kprobes/enabled works correctly for optimized kprobes.
> 
> 
>  kernel/kprobes.c |   18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> --
> Masami HIRAMATSU
> Software Platform Research Dpt. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 


