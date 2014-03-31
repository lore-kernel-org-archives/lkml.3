Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaCaCBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:01:08 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:49538 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaCaCBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140330005809.GY22728@two.firstfloor.org>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-16-git-send-email-jovi.zhangwei@gmail.com>
	<87d2h6nomj.fsf@tassilo.jf.intel.com>
	<CAGdX0WHEB7r0t_Bu6ME+gS=HxjFY9dnfn6azwyXe4U6sV7r0eQ@mail.gmail.com>
	<20140330005809.GY22728@two.firstfloor.org>
Date: Mon, 31 Mar 2014 10:01:04 +0800
Message-ID: <CAGdX0WFyuQu9bXBy-=9m=MiLBorNKr0MH9hhTvNNFYtWLg6d-g@mail.gmail.com>
Subject: Re: [PATCH 15/28] ktap: add built-in functions and library (runtime/lib_*.c)
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

On Sun, Mar 30, 2014 at 8:58 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Maybe in future, after ktap support "include" or "require" to
>> import user defined library in userspace.
>
> Can't you just have some hardcoded standard script for now that is
> always appeneded and provides these functions?
>
Maybe it's fine to hardcoded just for now.

Since we are agreed on review userspace part in another schedule,
so I will remove this ansi library from kernel part in next version.

Thanks for this suggestion.

Jovi
