Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaCEIpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:45:11 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64804 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaCEIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:45:10 -0500
Date: Wed, 5 Mar 2014 09:45:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] random: If we have arch_get_random_seed*(), try it
 before blocking
Message-ID: <20140305084506.GC2705@gmail.com>
References: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
 <1393972815-16689-4-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393972815-16689-4-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> If we have arch_get_random_seed*(), try to use it for emergency refill
> of the entropy pool before giving up and blocking on /dev/random.  It
> may or may not work in the moment, but if it does work, it will give
> the user better service than blocking will.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> ---
>  drivers/char/random.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
