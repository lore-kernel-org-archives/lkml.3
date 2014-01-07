Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaAGR1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:27:09 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45713 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752220AbaAGR1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:27:00 -0500
Date: Tue, 7 Jan 2014 17:26:32 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 0/5] generic early_ioremap support
Message-ID: <20140107172632.GC6234@arm.com>
References: <1389062120-31896-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389062120-31896-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:35:15AM +0000, Mark Salter wrote:
> This patch series takes the common bits from the x86 early ioremap
> implementation and creates a generic implementation which may be used
> by other architectures. The early ioremap interfaces are intended for
> situations where boot code needs to make temporary virtual mappings
> before the normal ioremap interfaces are available. Typically, this
> means before paging_init() has run.
> 
> These patches are layered on top of generic fixmap patches which
> were discussed here (and are in the akpm tree):
> 
>   http://lkml.org/lkml/2013/11/25/474
> 
> This is version 2 of the patch series. These patches (and underlying
> fixmap patches) may be found at:
> 
>   git://github.com/mosalter/linux.git (early-ioremap-v2 branch)

The patches look fine to me. I haven't acked the arm64 patches as I'll
eventually merge/sign them off once the first patch in the series goes
in.

Thanks.

-- 
Catalin
