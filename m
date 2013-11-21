Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3KUN4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:56:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:52027 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609Ab3KUN4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:56:36 -0500
Date: Thu, 21 Nov 2013 08:56:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121085633.6d274894@gandalf.local.home>
In-Reply-To: <20131121134949.GE26009@pd.tnic>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
	<20131121073410.GA16971@gmail.com>
	<20131121100722.GA25459@pd.tnic>
	<20131121111744.GA27513@gmail.com>
	<20131121113014.GA26009@pd.tnic>
	<20131121114224.GA27704@gmail.com>
	<20131121120605.GC26009@pd.tnic>
	<20131121123954.GA8044@home.goodmis.org>
	<20131121134949.GE26009@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 14:49:49 +0100
Borislav Petkov <bp@alien8.de> wrote:

> Anyway, arguments can be made for both, but I personally prefer leaving
> them separate. Unless there's a really compelling reason to have a
> single lib - a reason which I cannot think of right now...
> 

Honestly, I don't care if they are separate or in a single lib. The
important thing is to get it into a real library that distros ship.

-- Steve

