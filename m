Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaCKMJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:09:04 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21037 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753497AbaCKMJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:09:02 -0400
Date: Tue, 11 Mar 2014 12:08:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Will Deacon <Will.Deacon@arm.com>, Dave Young <dyoung@redhat.com>,
        Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v6 0/6] mm: generic early_ioremap support
Message-ID: <20140311120845.GG31104@arm.com>
References: <1394384444-23182-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394384444-23182-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Sun, Mar 09, 2014 at 05:00:38PM +0000, Mark Salter wrote:
> This patch series takes the common bits from the x86 early ioremap
> implementation and creates a generic implementation which may be used
> by other architectures. The early ioremap interfaces are intended for
> situations where boot code needs to make temporary virtual mappings
> before the normal ioremap interfaces are available. Typically, this
> means before paging_init() has run.
> 
> These patches are layered on top of generic fixmap patches which
> were pulled into upstream 3.14-rc kernels.
> 
> This is version 6 of the patch series. These patches fixmap patches
> may be found at:
> 
>   git://github.com/mosalter/linux.git (early-ioremap-v6 branch)

Are there any acks still needed? I think the arch patches in this series
have been acked, so I'm happy if hpa or someone else takes the whole
series.

Thanks.

-- 
Catalin
