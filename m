Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaG3WVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:21:30 -0400
Received: from mail.orcon.net.nz ([219.88.242.56]:40078 "EHLO
	mail.orcon.net.nz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753288AbaG3WV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:21:29 -0400
Date: Thu, 31 Jul 2014 10:21:13 +1200
From: Michael Cree <mcree@orcon.net.nz>
To: Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 2/2] alpha: Add sched_set/getattr and renameat2 syscalls
Message-ID: <20140730222113.GC23324@stolen.phys.waikato.ac.nz>
References: <1406756552-23864-1-git-send-email-rth@twiddle.net>
 <1406756552-23864-3-git-send-email-rth@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406756552-23864-3-git-send-email-rth@twiddle.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Bayes-Prob: 0.0001 (Score 0: No Bayes scoring rules defined, tokens from: outbound)
X-Spam-Score: -3.00 () [Hold at 3.00] FREEMAIL_FROM:0.001,CC(NZ:-3)
X-CanIt-Geo: ip=130.217.188.11; country=NZ; latitude=-41.0000; longitude=174.0000; http://maps.google.com/maps?q=-41.0000,174.0000&z=6
X-CanItPRO-Stream: base:outbound
X-Canit-Stats-ID: 02MwKlkGX - 31b93b71156a - 20140731
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:42:32AM -1000, Richard Henderson wrote:
> Signed-off-by: Richard Henderson <rth@twiddle.net>
> ---
>  arch/alpha/include/asm/unistd.h      | 2 +-
>  arch/alpha/include/uapi/asm/unistd.h | 3 +++
>  arch/alpha/kernel/systbls.S          | 3 +++
>  3 files changed, 7 insertions(+), 1 deletion(-)

I thought Matt had already sent my patch to do just that to Linus.

Cheers
Michael.
