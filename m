Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3FZJ4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:56:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49909 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3FZJ4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:56:35 -0400
Date: Wed, 26 Jun 2013 11:56:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130626095631.GB20274@pd.tnic>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
 <20130625191654.GH4855@pd.tnic>
 <20130626081223.GB21788@rric.localhost>
 <20130626082408.GA20274@pd.tnic>
 <20130626094634.GA29181@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130626094634.GA29181@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:46:34AM +0200, Ingo Molnar wrote:
> If already existing persistent events show up somewhere in sysfs
> (or in a separate pseudofilesystem) then an open() of them [given
> sufficient privileges of the caller, etc.] could attach to them.

Yep, I think we want to say sys_perf_event_open(attr.persistent=1) which
would give you a file descriptor to an already existing persistent event
with attr.config=<id>.

If it doesn't exist, it creates it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
