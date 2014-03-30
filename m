Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaC3Hk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 03:40:59 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:57624 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaC3Hk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 03:40:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140330035810.GD22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396017924-7754-14-git-send-email-jovi.zhangwei@gmail.com>
	<20140330035810.GD22728@two.firstfloor.org>
Date: Sun, 30 Mar 2014 15:40:57 +0800
Message-ID: <CAGdX0WFO3rn74PbEJ-wvQmcCurwSnEc376+TpdbohcTcDQP-3A@mail.gmail.com>
Subject: Re: [PATCH v2 13/29] ktap: add ring buffer handling code(kernel/trace/ktap/kp_transport.[c|h])
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 11:58 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>
>> A lot of code in this file is duplicated with kernel trace_output.c.
>
> Please modify trace_output instead to avoid this.
>
Yeah, ktap transport functionality is based on ftrace ring buffer,
and reading buffer is through trace pipe.

I will try to figure out some way to reuse ftrace trace pipe reading
code as much as possible.

Thanks.

Jovi
