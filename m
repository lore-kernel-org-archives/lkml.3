Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936569Ab3DJVJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:09:21 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:43253 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935212Ab3DJVJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:09:17 -0400
Date: Wed, 10 Apr 2013 14:09:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: Re: [PATCH UPDATED 1/7] x86: don't show trace into stacktrace
 machinery
Message-ID: <20130410210908.GG17641@mtj.dyndns.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
 <1365016497-32033-2-git-send-email-tj@kernel.org>
 <20130410201020.GF17641@mtj.dyndns.org>
 <20130410202220.GB6854@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410202220.GB6854@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:22:20PM +0200, Borislav Petkov wrote:
> This is double negation and is generally wrong in English. I think you
> want to say:
> 
> "%pf specified neither frame nor regs for ..."
> 
> or
> 
> "%pf didn't specify either frame or regs for ..."
> 
> Or maybe even passive and shorter:
> 
> "%pf: No frame or regs specified for %%current."
> 
> and so on.

Crap, right, will post an updated version soon.

Thanks!

-- 
tejun
