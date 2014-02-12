Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaBLL1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:27:52 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56566 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBLL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:27:50 -0500
Date: Wed, 12 Feb 2014 12:27:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Jiri Olsa <jolsa@redhat.com>,
        Patch Tracking <patches@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf: ARM64: wire up perf_regs and unwind support
Message-ID: <20140212112744.GA10517@gmail.com>
References: <1391451427-31221-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1kApRNN7aKQr89Y51w_JqUhVZ2x4+a8Sx8-X7xb-a1=pw@mail.gmail.com>
 <20140212101011.GC13441@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212101011.GC13441@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Deacon <will.deacon@arm.com> wrote:

> On Wed, Feb 12, 2014 at 08:46:38AM +0000, Jean Pihet wrote:
> > Hi Arnaldo, Will,
> > 
> > Ping on this patch.
> 
> This needs to go via the perf tree to avoid a repeat of the mess last time.

If the tooling bits are fine with Arnaldo then I have no objections 
either - once all the bits are acked please send a single series with 
all 4(?) patches in it, for tip:perf/core inclusion.

Thanks,

	Ingo
