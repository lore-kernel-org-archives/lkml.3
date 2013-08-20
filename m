Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3HTGmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:42:15 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61569 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3HTGmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:42:13 -0400
Date: Tue, 20 Aug 2013 08:42:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20130820064209.GB9518@gmail.com>
References: <20130819142633.82fb06bfa3bc0276fb09cbea@canb.auug.org.au>
 <20130819065817.GB23742@gmail.com>
 <20130820005234.GX19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820005234.GX19750@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > > Introduced by commit 9a55fdbe941e ("x86, asmlinkage, paravirt: Add
> > > __visible/asmlinkage to xen paravirt ops").  The 2 definitions used to be
> > > identical ... maybe there should be only one.
> > 
> > Andi, please send a fix for this build warning, against 
> > tip:x86/asmlinkage.
> 
> I resent the patch. Thanks for the headsup.

I suspect hpa missed it because the patch was opaque and 
non-descriptive: the title talks about a 'warning' that is 
supposedly fixed but the changelog does not explain what 
warning it is and why the change matters.

Please use the customary changelog style we use in the 
kernel:

  " Current code does (A), this has a problem when (B).
    We can improve this doing (C), because (D)."

I've seen this pattern of deficient changelogs a dozen 
times in your patches this year alone ...

Thanks,

        Ingo
