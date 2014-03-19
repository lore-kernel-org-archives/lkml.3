Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaCSRyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:54:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37047 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaCSRya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:54:30 -0400
Date: Wed, 19 Mar 2014 13:54:28 -0400 (EDT)
Message-Id: <20140319.135428.665886252770597921.davem@davemloft.net>
To: peterz@infradead.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 26/31] arch,sparc: Convert smp_mb__*
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140319065205.163413133@infradead.org>
References: <20140319064729.660482086@infradead.org>
	<20140319065205.163413133@infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Mar 2014 10:54:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 19 Mar 2014 07:47:55 +0100

> sparc32: fully relies on asm-generic/barrier.h and thus can use its
> 	 implementation.
> 
> sparc64: is strongly ordered and its atomic ops imply a full barrier,
> 	 implement the new primitives using barrier().
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Acked-by: David S. Miller <davem@davemloft.net>
