Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaCSRuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:50:21 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:6405 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaCSRuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:50:01 -0400
Message-ID: <5329D8C7.3070605@tilera.com>
Date: Wed, 19 Mar 2014 13:49:59 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
Newsgroups: linux-kernel
To: Peter Zijlstra <peterz@infradead.org>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <mingo@kernel.org>, <will.deacon@arm.com>,
        <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 27/31] arch,tile: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org> <20140319065205.215604416@infradead.org>
In-Reply-To: <20140319065205.215604416@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/2014 2:58 AM, Peter Zijlstra wrote:
> Implement the new smp_mb__* ops as per the old ones.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/tile/include/asm/atomic_32.h |   10 ----------
>  arch/tile/include/asm/atomic_64.h |    6 ------
>  arch/tile/include/asm/barrier.h   |   14 ++++++++++++++
>  arch/tile/include/asm/bitops.h    |    1 +
>  arch/tile/include/asm/bitops_32.h |    8 ++------
>  arch/tile/include/asm/bitops_64.h |    4 ----
>  6 files changed, 17 insertions(+), 26 deletions(-)

Looks good, thanks.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
