Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaBLNCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:02:32 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:43749 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaBLNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:02:14 -0500
Date: Wed, 12 Feb 2014 10:02:02 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Patch Tracking <patches@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf: ARM64: wire up perf_regs and unwind support
Message-ID: <20140212130202.GA7116@ghostprotocols.net>
References: <1391451427-31221-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1kApRNN7aKQr89Y51w_JqUhVZ2x4+a8Sx8-X7xb-a1=pw@mail.gmail.com>
 <20140212101011.GC13441@mudshark.cambridge.arm.com>
 <20140212112744.GA10517@gmail.com>
 <20140212113018.GA29132@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212113018.GA29132@mudshark.cambridge.arm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 12, 2014 at 11:30:18AM +0000, Will Deacon escreveu:
> On Wed, Feb 12, 2014 at 11:27:44AM +0000, Ingo Molnar wrote:
> > * Will Deacon <will.deacon@arm.com> wrote:
> > > This needs to go via the perf tree to avoid a repeat of the mess last time.

> > If the tooling bits are fine with Arnaldo then I have no objections 
> > either - once all the bits are acked please send a single series with 
> > all 4(?) patches in it, for tip:perf/core inclusion.
 
> I think it's just 1 patch -- the other 3 are under arch/arm64, so it would
> be easier to take those via the arm64 tree and deal with any conflicts
> there.

I don't have a problem with arch specific bits, that don't touch the
tools at all, going thru the respective arch git tree.

Jiri, can you see anything problematic in this? From a quick look I
couldn't.

- Arnaldo
