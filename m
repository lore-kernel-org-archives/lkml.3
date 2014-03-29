Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaC2EPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 00:15:09 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57987 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaC2EPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 00:15:08 -0400
MIME-Version: 1.0
In-Reply-To: <87d2h6nomj.fsf@tassilo.jf.intel.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-16-git-send-email-jovi.zhangwei@gmail.com>
	<87d2h6nomj.fsf@tassilo.jf.intel.com>
Date: Sat, 29 Mar 2014 12:15:07 +0800
Message-ID: <CAGdX0WHEB7r0t_Bu6ME+gS=HxjFY9dnfn6azwyXe4U6sV7r0eQ@mail.gmail.com>
Subject: Re: [PATCH 15/28] ktap: add built-in functions and library (runtime/lib_*.c)
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 2:51 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Jovi Zhangwei <jovi.zhangwei@gmail.com> writes:
>>
>> 2). Ansi library(lib_ansi.c):
>> ansi.clear_screen
>> ansi.set_color
>> ansi.set_color2
>> ansi.set_color3
>> ansi.reset_color
>> ansi.new_line
>
> This really can't be done in some kind of ktap library?
>
Maybe in future, after ktap support "include" or "require" to
import user defined library in userspace.

Thanks.

Jovi
