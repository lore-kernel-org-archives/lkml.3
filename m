Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3DLFmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:42:13 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:48967 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3DLFmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:42:11 -0400
Date: Fri, 12 Apr 2013 07:42:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <tj@kernel.org>
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
Subject: Re: [PATCHSET v2] arch: unify task dump debug info
Message-ID: <20130412054206.GD3887@gmail.com>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
 <20130408153107.GA3021@htj.dyndns.org>
 <20130411184750.GK17641@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411184750.GK17641@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> On Mon, Apr 08, 2013 at 08:31:07AM -0700, Tejun Heo wrote:
> > Andrew, ping?
> 
> Ping #2.  Workqueue conversion of writeback in the block tree needs
> these patches to avoid losing debug information over the conversion,
> so it'd be great if this can be scheduled for 3.10.

The x86 bits look good to me, assuming it's tested, etc.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
