Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3HLKG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:06:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab3HLKGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:06:54 -0400
Date: Mon, 12 Aug 2013 12:06:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] ftrace: Add initialization check in trace_printk for
 *puts paths
Message-ID: <20130812100644.GA1032@krava.brq.redhat.com>
References: <1376300045-3956-1-git-send-email-jolsa@redhat.com>
 <5208B293.2030906@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5208B293.2030906@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 06:01:55PM +0800, zhangwei(Jovi) wrote:
> On 2013/8/12 17:34, Jiri Olsa wrote:
> > Adding initialization check in trace_printk for *puts
> > paths, plus unifying the check for all related cases.
> > 
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > ---
> Missed Signed-off-by tag?

aaaargh... yes ;-) thanks

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
