Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3JUKyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:54:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35890 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab3JUKyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:54:03 -0400
Date: Mon, 21 Oct 2013 12:54:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Linux Torvalds <torvalds@osdl.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2] x86: add kconfig options for newer 64-bit processors
Message-ID: <20131021105401.GA5019@nazgul.tnic>
References: <526325C9.7030705@gmail.com>
 <20131020091813.GA4972@pd.tnic>
 <52646E0E.6040204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52646E0E.6040204@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 07:58:06PM -0400, Austin S Hemmelgarn wrote:
> I am not trying to say that this provides any improvement in speed (or
> at least the AMD options, the one for Intel Ivy Bridge processors does
> appear to do better in this respect).

"Does appear" is not a very good answer - you need to give concrete
benchmark results which people can repeat on their own and confirm your
observations.

> As I stated in the comments just before the patch itself, "...testing
> of MPILEDRIVER seems to indicate an improvement to energy efficiency
> over GENERIC_CPU as it causes the on cpu power sensor to consistently
> read an average of 1.5 watts lower under idle load than when
> using GENERIC_CPU (this corresponds to about 5% decrease in power
> consumption on a idle-tickless system, and about 2% on a non-dynticks
> system.).". While this result is dependent on a large number of
> factors (not the least of which being that I have my CPU over-clocked
> to the point that the lowest C-state runs at 1.4GHz, which really
> hurts energy efficiency) it is still a positive result, and most of
> the equivalent options primarily improve energy efficiency.

Again, how exactly do I reproduce your observations on my boxes? I need
a step-by-step walk through please.

> Also, you have to understand that my target audience isn't the
> mainstream distros,...

Well, if your target audience is only a very small fraction of the linux
users, then we don't need this in the mainline kernel in the first
place, do we?

Thanks.
