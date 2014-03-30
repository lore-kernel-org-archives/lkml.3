Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaC3H06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 03:26:58 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41147 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaC3H05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 03:26:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140329170445.GD31707@kroah.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-8-git-send-email-jovi.zhangwei@gmail.com>
	<87ha6inp7g.fsf@tassilo.jf.intel.com>
	<CAGdX0WFMXejHjhy5sVkVuQvNwE8MevEuAsDbkAZCb35mJj07zQ@mail.gmail.com>
	<20140329170445.GD31707@kroah.com>
Date: Sun, 30 Mar 2014 15:26:56 +0800
Message-ID: <CAGdX0WG7U97P-1VK539R2wWjr+5sqJ=TkHwr4xs74MzqPE4NdA@mail.gmail.com>
Subject: Re: [PATCH 07/28] ktap: add runtime/ktap.[c|h]
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 1:04 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Mar 29, 2014 at 03:32:12PM +0800, Jovi Zhangwei wrote:
>> >> +struct syscall_metadata **syscalls_metadata;
>> >> +
>> >> +/*TODO: kill this function in future */
>> >> +static int __init init_dummy_kernel_functions(void)
>> >> +{
>> >> +     unsigned long *addr;
>> >> +
>> >> +     /*
>> >> +      * ktap need symbol ftrace_profile_set_filter to set event filter,
>> >> +      * export it in future.
>> >
>> > Obviously you need to fix that. Just export the symbols.
>> >
>> Yeah, will do after kernel community decide to merge ktap. :)
>
> We already said we wanted it merged, so please send patches that do it
> properly, by exporting the needed symbols as part of the patch series.
>
Sure, I will fix it in next version.

Thanks.

Jovi
