Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3HKRzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 13:55:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab3HKRzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:55:12 -0400
Date: Sun, 11 Aug 2013 19:49:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: kill the no longer needed PITA code
Message-ID: <20130811174929.GA12119@redhat.com>
References: <20130731173116.GA31018@redhat.com> <1375292913.5418.8.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375292913.5418.8.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Steven Rostedt wrote:
>
> On Wed, 2013-07-31 at 19:31 +0200, Oleg Nesterov wrote:
> > Hello.
> >
> > Simple cleanups on top of the recent (already applied)
> > id/filter/format/enable changes.
> >
> > f_op->owner == mod is no longer needed and can go away.
> >
>
> This patch set is not needed for 3.11. I'll be holding off my review
> until I have all the 3.11 patches settled.

It seems that you have no more 3.11 patches.

Should I resend this series?

Oleg.

