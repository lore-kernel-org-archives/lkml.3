Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaIOQ0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:26:38 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33030 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaIOQ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:26:37 -0400
Date: Mon, 15 Sep 2014 17:26:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "behanw@converseincode.com" <behanw@converseincode.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "jays.lee@samsung.com" <jays.lee@samsung.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] arm64: LLVMLinux: Fix inline arm64 assembly for use with
 clang
Message-ID: <20140915162624.GH5415@arm.com>
References: <20140909101515.GB1754@arm.com>
 <1410759015-15642-1-git-send-email-behanw@converseincode.com>
 <20140915160240.GC29744@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915160240.GC29744@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 05:02:41PM +0100, Will Deacon wrote:
> On Mon, Sep 15, 2014 at 06:30:15AM +0100, behanw@converseincode.com wrote:
> > From: Mark Charlebois <charlebm@gmail.com>
> > 
> > Remove '#' from immediate parameter in AARCH64 inline assembly in mmu.
> > 
> > This code now works with both gcc and clang.
> > 
> > Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> > Signed-off-by: Behan Webster <behanw@converseincode.com>
> > ---
> >  arch/arm64/mm/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Thanks, Behan!
> 
> Catalin: please can you pick this up for 3.18? It's probably not worth me
> merging it as a fix, since there are other patches needed to get us building
> under clang anyway.

I agree, it will go in for 3.18 rather than 3.17.

-- 
Catalin
