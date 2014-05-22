Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaEVSPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:15:43 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:34418 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaEVSPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:15:41 -0400
Message-ID: <537E3EC7.1030904@twiddle.net>
Date: Thu, 22 May 2014 11:15:35 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH v2 05/18] alpha: io: implement relaxed accessor macros
 for writes
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com> <1400777250-17335-6-git-send-email-will.deacon@arm.com>
In-Reply-To: <1400777250-17335-6-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 09:47 AM, Will Deacon wrote:
> write{b,w,l,q}_relaxed are implemented by some architectures in order to
> permit memory-mapped I/O writes with weaker barrier semantics than the
> non-relaxed variants.
> 
> This patch implements these write macros for Alpha, in the same vein as
> the relaxed read macros, which are already implemented.
> 
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/alpha/include/asm/io.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Acked-by: Richard Henderson <rth@twiddle.net>


r~
