Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaAXPXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:23:43 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20700 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752628AbaAXPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:23:41 -0500
Date: Fri, 24 Jan 2014 15:23:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: delete non-required instances of <linux/init.h>
Message-ID: <20140124152308.GE19052@arm.com>
References: <1390501611-31691-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390501611-31691-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 06:26:51PM +0000, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one place to the next.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> 
> [Build tested on today's linux-next ; thanks to Will for the pointer
>  to a prebuilt toolchain.  Patch to be added to init cleanup series:
>    http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git   ]

I assume you are pushing this upstream as part of your cleanup series.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
