Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaCBU4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:56:21 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58861 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaCBU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:56:20 -0500
Date: Sun, 2 Mar 2014 21:56:19 +0100
From: Andreas Mohr <andi@lisas.de>
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: Dennis Mungai <dmngaie@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140302205619.GA8676@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228140043.GA12157@debian.local>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>  	/*
> +	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
> +	 */

Ain't that a tad strongly/incorrectly worded?

It's probably not certain whether that's a "bug".
Prior content in this discussion suggested that the flag might have been
intentionally not advertised, due to not being of sufficient quality
yet in these revisions.
Also, it's not definite that it has "PAE" in a usable form.

So what about rewording it into an "issue", e.g. something like:

"PAE CPUID issue: most Pentium M report no PAE but may have PAE
implemented at a potentially usable quality level.

Thank you very much for this important deescalation work of the quite annoying
PAE compat issue! (Pentium M, AMD Geode, VIA C7, <(=?) Pentium II, ...)

(BTW, would it be possible to transform Linux's PAE support into
boot-config or even fully runtime-detectable boot switching to
(non-)PAE, similar to or exceeding what XP offers with its static
boot-time flag?
Last time I checked PAE support config defines were spread over ~ 40
kernel source files though :-((()

Andreas Mohr
