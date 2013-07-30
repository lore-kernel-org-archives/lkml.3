Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3G3JuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:50:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57328 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932397Ab3G3JuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:50:07 -0400
Date: Tue, 30 Jul 2013 10:49:04 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Dave P Martin <Dave.Martin@arm.com>, Robert Richter <rric@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jed Davis <jld@mozilla.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
 [OT]
Message-ID: <20130730094904.GH11527@mudshark.cambridge.arm.com>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
 <20130715135420.GG10000@mudshark.cambridge.arm.com>
 <20130720044655.GC9433@mozilla.com>
 <20130721213753.GA29879@mudshark.cambridge.arm.com>
 <20130722185234.GA14519@localhost.localdomain>
 <20130729212140.GB12681@mozilla.com>
 <20130730092517.GB2478@localhost.localdomain>
 <20130730113853.46cbb00a@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730113853.46cbb00a@armhf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:38:53AM +0100, Jean-Francois Moine wrote:
> BTW, kernels compiled with gcc-4.8 don't work.

Erm. Can you elaborate please? There was an issue where SLUB would get
miscompiled with 4.8 due to some per-cpu variable reordering across
barrier(), but I fixed that for ARM in 3.10.

... or are you referring specifically to the unwinder?

Will
