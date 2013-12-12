Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3LLCFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:05:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab3LLCFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:05:21 -0500
Date: Thu, 12 Dec 2013 10:04:26 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v5 02/14] efi: use early_memremap and early_memunmap
Message-ID: <20131212020426.GA3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-3-git-send-email-dyoung@redhat.com>
 <20131211103903.GC19196@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211103903.GC19196@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 at 10:39am, Matt Fleming wrote:
> (Cc'ing Leif and Mark for the ARM-side of things)
> 
> On Mon, 09 Dec, at 05:42:15PM, Dave Young wrote:
> > In arch/x86/platform/efi/efi.c and drivers/firmware/efi/efi.c turn to use
> > early_memremap/early_memunmap instead of early_ioremap/early_iounmap so sparse
> > will be happy.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/platform/efi/efi.c | 20 ++++++++++----------
> >  drivers/firmware/efi/efi.c  |  4 ++--
> >  2 files changed, 12 insertions(+), 12 deletions(-)
>  
> This looks like a rather nice cleanup but the commit log could use a
> little bit of tweaking...
> 
>   - Please start your commit title (the part after the subsystem tag)
>     with a capital letter, e.g.
> 
>       efi: Use early_memremap...
> 
>   - You need to explain in the commit title that you're fixing a sparse
>     warning. Anyone reading the patch subject will have no idea _why_
>     you're using early_memremap() and early_memunmap().
> 
>   - In the commit message body explain why sparse is currently unhappy.

Sure, will do.

--
Thanks for review
Dave
