Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3FZIYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:24:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46686 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab3FZIYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:24:12 -0400
Date: Wed, 26 Jun 2013 10:24:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130626082408.GA20274@pd.tnic>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
 <20130625191654.GH4855@pd.tnic>
 <20130626081223.GB21788@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130626081223.GB21788@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:12:23AM +0200, Robert Richter wrote:
> We get a new fd by opening the persistent event with the syscall.
> There would be 2 new ioctls:
> 
>  ioctl(fd, PERF_EVENT_IOC_DETACH, 0);
>  ioctl(fd, PERF_EVENT_IOC_ATTACH, 0);
> 
> This would be fine and reuses existing infrastructure.

Well, how are you going to say that you want to open an already existing
persistent event or your want to create exactly the same persistent
event? Are we even going to allow identical persistent events to
coexist?

The answers to those questions gives us the implementation.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
