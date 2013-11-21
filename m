Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3KUP2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:28:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58453 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KUP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:28:13 -0500
Date: Thu, 21 Nov 2013 16:28:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121152804.GI26009@pd.tnic>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131121150524.GA24806@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 12:05:24PM -0300, Arnaldo Carvalho de Melo wrote:
> "To offers various helper methods to interface with the Linux kernel:
>  debugfs, procfs, sysfs handling routines with no policy, just pure,
>  obvious helpers to use kernel functionality."

Exactly.

> Naming is a bit hard, to keep it small, descriptive, as API can lead
> people to think about other kinds of kernel APIs (syscalls?), "fskapi"
> to mean "fs based kernel API" would perhaps be more descriptive? A
> longer (more descriptive) possibility would be "linux-fskapi".

Yeah, you can't have fskapi because we'll add other stuff to it (see
the diffstat I sent you last week) so not filesystem stuff only. So I
think "kapi" is as generic and as fitting as it gets. We can use the
"kernel-api" variant but I think the "k" is enough.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
