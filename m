Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbaCULzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:55:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:39738 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752119AbaCULzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:55:12 -0400
Date: Fri, 21 Mar 2014 11:54:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 07/31] arch,arm64: Convert smp_mb__*
Message-ID: <20140321115447.GB14251@arm.com>
References: <20140319064729.660482086@infradead.org>
 <20140319065204.150839038@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319065204.150839038@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 07:47:36AM +0100, Peter Zijlstra wrote:
> AARGH64 uses ll/sc primitives that do not imply any barriers for the
> normal atomics, therefore smp_mb__{before,after} should be a full
> barrier.
> 
> Since AARGH64 doesn't use asm-generic/barrier.h, add the required
> definitions to its asm/barrier.h.

There is a typo above ;)

Otherwise,

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
