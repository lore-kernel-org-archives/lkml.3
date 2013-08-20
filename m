Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3HTAwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:52:39 -0400
Received: from one.firstfloor.org ([193.170.194.197]:56693 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3HTAwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:52:37 -0400
Date: Tue, 20 Aug 2013 02:52:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20130820005234.GX19750@two.firstfloor.org>
References: <20130819142633.82fb06bfa3bc0276fb09cbea@canb.auug.org.au>
 <20130819065817.GB23742@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819065817.GB23742@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Introduced by commit 9a55fdbe941e ("x86, asmlinkage, paravirt: Add
> > __visible/asmlinkage to xen paravirt ops").  The 2 definitions used to be
> > identical ... maybe there should be only one.
> 
> Andi, please send a fix for this build warning, against 
> tip:x86/asmlinkage.

I resent the patch. Thanks for the headsup.
-Andi
