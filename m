Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3EJJuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:50:18 -0400
Received: from relay2.sgi.com ([192.48.179.30]:44762 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751576Ab3EJJuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:50:17 -0400
Date: Fri, 10 May 2013 04:50:14 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <rja@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v9 04/11] Move shutdown/reboot related functions to
 kernel/reboot.c
Message-ID: <20130510095014.GY3658@sgi.com>
References: <1368127405-112717-1-git-send-email-holt@sgi.com>
 <1368127405-112717-5-git-send-email-holt@sgi.com>
 <20130509135100.13947d1805a583703ee8488b@linux-foundation.org>
 <20130510000552.GX3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510000552.GX3658@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 07:05:53PM -0500, Robin Holt wrote:
> On Thu, May 09, 2013 at 01:51:00PM -0700, Andrew Morton wrote:
> > On Thu,  9 May 2013 14:23:18 -0500 Robin Holt <holt@sgi.com> wrote:
> > 
> > > This patch is preparatory.  It moves reboot related syscall, etc
> > > functions from kernel/sys.c to kernel/reboot.c.
> > 
> > This doesn't apply.
> 
> Weird, I just grabbed a recent Linus kernel tree and all 11 applied.
> I then did an update to linus' tree to commit 70eba4226 and now I get
> rejects on arm.  I will resubmit a -v10 fixed up shortly.

I wonder what you are seeing.  I get all 11 to apply fairly cleanly with
only arch/arm/mach-imx/common.h getting conflicts on a commits after 009e63f
which are related to context.  Otherwise, they applied cleanly.  I assume
you removed the earlier version before trying to apply.

I can resubmit (and will add Ingo's Acked-by), but am not sure it is
going to help the situation.  How would you like me to proceed?

Robin
