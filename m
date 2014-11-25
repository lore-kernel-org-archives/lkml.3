Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaKYTfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:35:32 -0500
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:44750 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750888AbaKYTfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:35:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3867:3868:3870:3871:3872:4321:5007:6238:6261:6742:6743:10004:10400:10848:11658:11914:12043:12296:12517:12519:12555:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: book09_120ea818f5010
X-Filterd-Recvd-Size: 2205
Message-ID: <1416944122.8358.10.camel@perches.com>
Subject: Re: [PATCH v6 5/5] patch to allow arm cross-compile
From: Joe Perches <joe@perches.com>
To: Alexander Duyck <alexander.h.duyck@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        peterz@infradead.org, benh@kernel.crashing.org,
        heiko.carstens@de.ibm.com, mingo@kernel.org, mikey@neuling.org,
        linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, arnd@arndb.de,
        will.deacon@arm.com, michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com, davem@davemloft.net
Date: Tue, 25 Nov 2014 11:35:22 -0800
In-Reply-To: <20141125183322.1486.90766.stgit@ahduyck-server>
References: <20141125183009.1486.20845.stgit@ahduyck-server>
	 <20141125183322.1486.90766.stgit@ahduyck-server>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Russell King)

On Tue, 2014-11-25 at 10:33 -0800, Alexander Duyck wrote:
> ---
>  arch/arm/kernel/asm-offsets.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index 2d2d608..6f8e79c 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -49,10 +49,6 @@
>  #error Your compiler is too buggy; it is known to miscompile kernels.
>  #error    Known good compilers: 3.3, 4.x
>  #endif
> -#if GCC_VERSION >= 40800 && GCC_VERSION < 40803
> -#error Your compiler is too buggy; it is known to miscompile kernels
> -#error and result in filesystem corruption and oopses.
> -#endif
>  #endif



