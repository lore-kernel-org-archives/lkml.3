Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaEUQIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:08:12 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:49708 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUQIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:08:10 -0400
X-Auth-Info: SDB1h4c9xwuu5EzsxTkZPAt+FpTJzKiVDCWWhsL+sbs=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: fix typo 'CONFIG_PMAC'
References: <1400617498.4912.66.camel@x220>
X-Yow: Look!  A ladder!  Maybe it leads to heaven, or a sandwich!
Date: Wed, 21 May 2014 18:08:04 +0200
In-Reply-To: <1400617498.4912.66.camel@x220> (Paul Bolle's message of "Tue, 20
	May 2014 22:24:58 +0200")
Message-ID: <874n0j3yjf.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:

> Commit b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling
> perf_event_do_pending") added a check for CONFIG_PMAC were a check for
> CONFIG_PPC_PMAC was clearly intended.
>
> Fixes: b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling perf_event_do_pending")
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. Needs testing on 32 bit powermac, I guess.
>
> This typo was introduced in v2.6.36. No one noticed because very few
> people still use 32 bit powermacs?

How does that bug manifest itself?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
