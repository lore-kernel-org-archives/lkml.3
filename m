Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3EPVea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:34:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48836 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab3EPVe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:34:28 -0400
Date: Thu, 16 May 2013 23:34:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130516213420.GB31393@pd.tnic>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130516205558.GE8356@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:55:58PM +0200, Robert Richter wrote:
> iirc the reason was the different msr range that is switched on fam15h
> with a different counter to counter msr offset of 2 instead of 1. The
> code relies on the assumption that the msrs exist on that cpu. Thus
> the warning if not. Also note that code may have changed in 3.10 in
> that area.

Stupid question: why is check_hw_exists() *after* the vendor-specific
counter detection code in init_hw_perf_events() even though it is
supposed to check whether hardware is emulated?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
