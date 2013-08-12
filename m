Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3HLRVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab3HLRVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:21:48 -0400
Date: Mon, 12 Aug 2013 19:16:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: kill the no longer needed PITA code
Message-ID: <20130812171602.GA1785@redhat.com>
References: <20130731173116.GA31018@redhat.com> <1375292913.5418.8.camel@gandalf.local.home> <20130811174929.GA12119@redhat.com> <20130811202040.4812c568@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130811202040.4812c568@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Steven Rostedt wrote:
>
> On Sun, 11 Aug 2013 19:49:29 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > It seems that you have no more 3.11 patches.
> >
> > Should I resend this series?
>
> Only if it changed.

No, they still apply cleanly, just the offsets differ a bit.

> I'll be looking into 3.12 patches come Monday.

Great, thanks.

Oleg.

