Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab3GaOfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab3GaOfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:35:00 -0400
Date: Wed, 31 Jul 2013 16:29:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [for-next-3.11][PATCH 0/8] ftrace/tracing: Event file fixes
	and ftrace function hash fixes
Message-ID: <20130731142937.GA32023@redhat.com>
References: <20130730112718.273490378@goodmis.org> <20130731114722.GA4416@redhat.com> <1375279617.19999.1.camel@gandalf.local.home> <20130731142236.GA31073@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731142236.GA31073@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for noise, forgot to mention...

On 07/31, Oleg Nesterov wrote:
>
> Just I think that "open/delete fixes" is not complete without this fix.

And without the last "tracing: trace_remove_event_call() should fail if
call/file is in use" or something similar.

Oleg.

