Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab3KZOor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:44:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:14139 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756949Ab3KZOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:44:43 -0500
Date: Tue, 26 Nov 2013 09:44:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 3.13-rc1 kernel crash when enable all tracepoints
Message-ID: <20131126094441.7bc4ff43@gandalf.local.home>
In-Reply-To: <CAKocOOOMEsUCux27f7S1k7ecanfzXoNnP5319zgnGWMhqOimiQ@mail.gmail.com>
References: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com>
	<20131126075859.2060f6fd@gandalf.local.home>
	<CAKocOOOMEsUCux27f7S1k7ecanfzXoNnP5319zgnGWMhqOimiQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013 07:32:43 -0700
Shuah Khan <shuahkhan@gmail.com> wrote:

> I sent in a patch to fix it. You can try the patch out if you like,
> 
> https://lkml.org/lkml/2013/11/22/337

That was the patch I sent to you.

  https://lkml.org/lkml/2013/11/20/637

I wanted you to test it, not submit it as your own. I have it in my
queue.

-- Steve

