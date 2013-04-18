Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967142Ab3DROf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:35:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34063 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965239Ab3DROfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:35:25 -0400
Date: Thu, 18 Apr 2013 15:34:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, msalter@redhat.com, starvik@axis.com,
        dhowells@redhat.com, tony.luck@intel.com, benh@kernel.crashing.org,
        takata@linux-m32r.org, geert@linux-m68k.org, james.hogan@imgtec.com,
        monstr@monstr.eu, ralf@linux-mips.org, jonas@southpole.se,
        rkuo@codeaurora.org, schwidefsky@de.ibm.com, liqin.chen@sunplusct.com,
        davem@davemloft.net, lethal@linux-sh.org, vgupta@synopsys.com,
        chris@zankel.net, cmetcalf@tilera.com, ysato@users.sourceforge.jp,
        gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: Re: [PATCHSET v2] arch: unify task dump debug info
Message-ID: <20130418143446.GV14496@n2100.arm.linux.org.uk>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365016497-32033-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 12:14:50PM -0700, Tejun Heo wrote:
> Andrew, I think it's about ready and nobody seems to be against the
> proposed changes.  Can you please take these into -mm?
> 
> This v2 of this patchset.  Changes from the last posting[1] are,

So, I've just tried to apply this patch to my current testing tree,
and it fails because I'm not using -mm...  That means I can't put
these in my nightly testing tree.
