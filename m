Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaGKQS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:18:27 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:53209 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751130AbaGKQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:18:26 -0400
Date: Fri, 11 Jul 2014 17:18:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <Will.Deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] asm-generic/io.h: Implement generic
 {read,write}s*()
Message-ID: <20140711161811.GE16321@arm.com>
References: <1405092672-18549-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405092672-18549-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 04:31:10PM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This patch implements generic versions of readsb(), readsw(), readsl(),
> readsq(), writesb(), writesw(), writesl() and writesq(). Variants of
> these string functions for I/O accesses (ins*() and outs*() as well as
> ioread*_rep() and iowrite*_rep()) are now implemented in terms of the
> new functions.
> 
> While at it, also make sure that any of the functions provided as
> fallback for architectures that don't override them can't be overridden
> subsequently.
> 
> This is compile- and runtime-tested on 32-bit and 64-bit ARM and compile
> tested on Microblaze, s390, SPARC and Xtensa. For ARC, Blackfin, Metag,
> OpenRISC, Score and Unicore32 which also use asm-generic/io.h I couldn't
> find or build a cross-compiler that would run on my system. But by code
> inspection they shouldn't break with this patch.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
