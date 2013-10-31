Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3JaLXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:23:36 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46598 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3JaLXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:23:35 -0400
Date: Thu, 31 Oct 2013 12:23:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@suse.de>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, oleg@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sherry.hurwitz@amd.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131031112328.GF2253@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20131031095829.GE2253@localhost.localdomain>
 <20131031104836.GC10544@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031104836.GC10544@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 11:48:36AM +0100, Borislav Petkov wrote:
> fix tglx's address.
> 
> On Thu, Oct 31, 2013 at 10:58:31AM +0100, Frederic Weisbecker wrote:
> > Is this perhaps a bit too generic? Extension can mean about everything
> > and who knows what other feature Intel and Amd will add to breakpoints
> > in the future.
> 
> Yeah, but that's the name of the feature. When they come up with another
> extension, they'll call it BP_EXT2, most probably...
> 
> :-)

:-)

Ok we can keep that naming then, at least on the feature symbol. But add a comment
on it.
