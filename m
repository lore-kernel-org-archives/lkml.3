Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab3G3Jqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:46:33 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44412 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758798Ab3G3Jqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:46:30 -0400
Date: Tue, 30 Jul 2013 10:44:57 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Jed Davis <jld@mozilla.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
 [OT]
Message-ID: <20130730094457.GC2478@localhost.localdomain>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
 <20130715135420.GG10000@mudshark.cambridge.arm.com>
 <20130720044655.GC9433@mozilla.com>
 <20130721213753.GA29879@mudshark.cambridge.arm.com>
 <20130722185234.GA14519@localhost.localdomain>
 <20130729212140.GB12681@mozilla.com>
 <20130730092517.GB2478@localhost.localdomain>
 <20130730113853.46cbb00a@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130730113853.46cbb00a@armhf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 11:38:53AM +0200, Jean-Francois Moine wrote:
> On Tue, 30 Jul 2013 10:25:18 +0100
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> > The pragmatic route is less contraversial and lower overhead: even though
> > it's not correct as per the ABI, GCC is the only supported compiler for
> > building the kernel anyway.
> 
> BTW, kernels compiled with gcc-4.8 don't work.

I haven't tried 4.8 yet.  Do you know what the problem is?

> Did anybody succeed with clang?

Hmm, I've no idea.  Is this possible?

Cheers
---Dave

> 
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
