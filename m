Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaCaDWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 23:22:15 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:44420 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaCaDWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 23:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <5338D037.5090207@huawei.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396017924-7754-17-git-send-email-jovi.zhangwei@gmail.com>
	<5338D037.5090207@huawei.com>
Date: Mon, 31 Mar 2014 11:22:13 +0800
Message-ID: <CAGdX0WErzdGZ_yZnWaHNbzHzxSHOWYyKJoQTKCgJBpMw_zR1cQ@mail.gmail.com>
Subject: Re: [PATCH v2 16/29] ktap: add amalgamation build(kernel/trace/ktap/amalg.c)
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:17 AM, Li Zefan <lizefan@huawei.com> wrote:
> On 2014/3/28 22:45, Jovi Zhangwei wrote:
>> This compiles the ktapvm as one huge C file and allows
>> GCC to generate faster and shorter code.
>>
>> No amalgamation build in x86_64:
>> ktapvm.ko: 3.1M
>>
>> amalgamation build in x86_64:
>> ktapvm.ko: 1.1M
>>
>> User can set use amalgamation build or not in Makefile.
>>
>> (Need to analyze further why have so big differences)
>>
>
> Let's drop this patch for now to make the patchset smaller ?
>
Sure, I will analyze the size difference and find the root cause offline.

Thanks for this suggestion.

Jovi.
