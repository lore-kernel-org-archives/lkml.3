Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab3FRNxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:53:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36737 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932701Ab3FRNxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:53:21 -0400
Date: Tue, 18 Jun 2013 14:52:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64/Makefile: provide vdso_install target
Message-ID: <20130618135250.GH6801@mudshark.cambridge.arm.com>
References: <20130616193243.GC8939@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130616193243.GC8939@redacted.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 08:32:44PM +0100, Kyle McMartin wrote:
> Provide a vdso_install target in the arm64 Makefile, as other architectures
> with a vdso do.

Thanks Kyle.

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -60,6 +60,10 @@ zinstall install: vmlinux
>  dtbs: scripts
>  	$(Q)$(MAKE) $(build)=$(boot)/dts dtbs
>  
> +PHONY += vdso_install
> +vdso_install:
> +	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso $@
> +
>  # We use MRPROPER_FILES and CLEAN_FILES now
>  archclean:
>  	$(Q)$(MAKE) $(clean)=$(boot)
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
