Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaC3JSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 05:18:15 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:51718 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaC3JSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 05:18:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140330010033.GZ22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
	<20140330010033.GZ22728@two.firstfloor.org>
Date: Sun, 30 Mar 2014 17:18:13 +0800
Message-ID: <CAGdX0WHz==fazej3OG2SS8ZUm2bEX3OeB51M4hi3ZbgL8wU_Ew@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/29] ktap: A lightweight dynamic tracing tool for Linux
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

On Sun, Mar 30, 2014 at 9:00 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> For now I would suggest concentrating on the kernel ring 0 parts only.
> Split the user space part into a separate patchkit that is posted
> on a separate schedule.
>
> It's hard to make progress with too large patchkits.
>
Agreed, we can only focus on kernel module now, userspace part
is much simple, just a one pass compiler.

I will only send kernel module part in next version.

Thanks for this suggestion.

Jovi
