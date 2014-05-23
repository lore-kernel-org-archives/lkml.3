Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaEWJXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:23:47 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24368 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751178AbaEWJXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:23:46 -0400
Date: Fri, 23 May 2014 10:23:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Steve Capper <steve.capper@linaro.org>
Subject: Re: linux-next: manual merge of the tip tree with the arm64 tree
Message-ID: <20140523092329.GB9252@arm.com>
References: <20140523164402.37eceb11@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523164402.37eceb11@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 07:44:02AM +0100, Stephen Rothwell wrote:
> Today's linux-next merge of the tip tree got a conflict in
> arch/arm64/mm/mmu.c between commit a501e32430d4 ("arm64: Clean up the
> default pgprot setting") and 206a2a73a62d ("arm64: mm: Create gigabyte
> kernel logical mappings where possible") from the arm64 tree and commit
> d7ecbddf4cae ("arm64: Add function to create identity mappings") from
> the tip tree.
> 
> I fixed it up (maybe - see below - this may not be complete) and can
> carry the fix as necessary (no action is required).

Thanks for fixing it up, it is correct.

(but I now have to go after the arm64 EFI_STUB guys as it breaks non-EFI
booting).

-- 
Catalin
