Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaBYOk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:40:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbaBYOkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:40:23 -0500
Message-ID: <1393337404.7307.51.camel@deneb.redhat.com>
Subject: Re: [PATCH v4 0/6] generic early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Dave Young <dyoung@redhat.com>,
        Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, patches@linaro.org
Date: Tue, 25 Feb 2014 09:10:04 -0500
In-Reply-To: <1392238575-10000-1-git-send-email-msalter@redhat.com>
References: <1392238575-10000-1-git-send-email-msalter@redhat.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 15:56 -0500, Mark Salter wrote:
> This patch series takes the common bits from the x86 early ioremap
> implementation and creates a generic implementation which may be used
> by other architectures. The early ioremap interfaces are intended for
> situations where boot code needs to make temporary virtual mappings
> before the normal ioremap interfaces are available. Typically, this
> means before paging_init() has run.
> 
> These patches are layered on top of generic fixmap patches which
> were pulled into 3.14-rc with the exception of the arm patch:
> 
>   https://lkml.org/lkml/2013/11/25/477
> 
> The arm fixmap patch is currently in the akpm tree and has been
> part of linux-next for a while.
> 
> This is version 4 of the patch series. These patches (and underlying
> fixmap patches) may be found at:
> 
>   git://github.com/mosalter/linux.git (early-ioremap-v4 branch)

There have been no comments on this patch series over the past
two weeks. I'd like to get it into linux-next for some wider
testing and eventually into 3.15. Is there something I can do
to help it along?


