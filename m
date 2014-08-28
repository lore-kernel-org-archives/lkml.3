Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaH1NEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:04:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:48522 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaH1NEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:04:21 -0400
Message-ID: <53FF28BE.60502@windriver.com>
Date: Thu, 28 Aug 2014 09:03:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "David S. Miller" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Remove various orphaned header files
References: <1409226274-3202-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1409226274-3202-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-08-28 07:44 AM, Rasmus Villemoes wrote:
> These four files are not included anywhere, and seem to be accidental
> leftovers from past cleanups (see the individual commit messages).
> 
> Rasmus Villemoes (4):
>   include/linux/cycx_x25.h: Remove unused header
>   include/linux/i82593.h: Remove unused header
>   include/linux/phonedev.h: Remove unused header
>   include/rxrpc/types.h: Remove unused header

Strictly speaking the phonedev.h and types.h were not orphaned
by net-next commits, but I suppose it is no harm if they go
via net-next vs. say 3 in Greg's staging and 4 in akpm's tree.

I double checked that they are not used anywhere with
git grep, so...

Reviewed-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Thanks,
Paul.
--

> 
>  include/linux/cycx_x25.h | 125 --------------------------
>  include/linux/i82593.h   | 229 -----------------------------------------------
>  include/linux/phonedev.h |  25 ------
>  include/rxrpc/types.h    |  41 ---------
>  4 files changed, 420 deletions(-)
>  delete mode 100644 include/linux/cycx_x25.h
>  delete mode 100644 include/linux/i82593.h
>  delete mode 100644 include/linux/phonedev.h
>  delete mode 100644 include/rxrpc/types.h
> 
