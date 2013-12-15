Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3LONXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 08:23:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59448 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab3LONXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 08:23:32 -0500
Date: Sun, 15 Dec 2013 14:23:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: John <da_audiophile@yahoo.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david.heidelberger@ixit.cz" <david.heidelberger@ixit.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
Message-ID: <20131215132329.GC4361@pd.tnic>
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com>
 <864985fbeb1d8148439e25ec01f47a67@ixit.cz>
 <52AAFF89.5080509@gmail.com>
 <1387051250.86178.YahooMailNeo@web140005.mail.bf1.yahoo.com>
 <ce679ca5-bf83-4c2a-9234-859cc7a4206b@email.android.com>
 <1387057337.97000.YahooMailNeo@web140004.mail.bf1.yahoo.com>
 <52ACECC4.208@zytor.com>
 <1387108841.76039.YahooMailNeo@web140006.mail.bf1.yahoo.com>
 <CAFLxGvxakZS5FFQcZ_ogTd9aUENT3ECj2Lxs+FCbZAiGqgOJ7g@mail.gmail.com>
 <1387111370.81380.YahooMailNeo@web140001.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1387111370.81380.YahooMailNeo@web140001.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 04:42:50AM -0800, John wrote:
> I am using ANOVA to establish that the generic group differs from the
> optimized group.

You probably should run a couple other benchmarks, in addition, for
greater confidence that this optimization actually brings any palpable
improvement and is not just causing code bloat.

For example, last time I did a perf profile of a kernel build on AMD
F15h, the PILERDRIVER "optimization" was actually even a bit worse than
the standard MK8 one.

http://marc.info/?l=linux-kernel&m=138081947417204

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
