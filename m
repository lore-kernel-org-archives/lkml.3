Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaIOMDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:03:19 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49386 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaIOMDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:03:18 -0400
Date: Mon, 15 Sep 2014 17:33:03 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] drivers: char: hw_random: printk replacement
Message-ID: <20140915120303.GA27044@sudip-PC>
References: <1409238178-16496-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140915114123.GA4843@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140915114123.GA4843@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 07:41:23PM +0800, Herbert Xu wrote:
> On Thu, Aug 28, 2014 at 08:32:58PM +0530, Sudip Mukherjee wrote:
> > as pr_* macros are more preffered over printk, so printk replaced with corresponding pr_* macros
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> 
> Your patch doesn't even build:
> 
>   CC [M]  drivers/char/hw_random/intel-rng.o
>   CC [M]  drivers/char/hw_random/amd-rng.o
>   CC [M]  drivers/char/hw_random/via-rng.o
>   drivers/char/hw_random/intel-rng.c: In function ‘intel_init_hw_struct’:
>   drivers/char/hw_random/intel-rng.c:317:3: error: expected ‘)’ before ‘warning’
>   drivers/char/hw_random/intel-rng.c:308:36: warning: unused variable ‘warning’ [-Wunused-variable]
>   make[1]: *** [drivers/char/hw_random/intel-rng.o] Error 1
> 
> Cheers,
> -- 

i am extremely sorry for the mess. after applying the patch i tested with allmodconfig
and seeing no error i thought it was ok. but now after your mail when i am verifying i
noticed that allmodconfig is not including it in the config and as a result it was not tested.

i will post a corrected v2 of the patch.

sorry again,

thanks
sudip


> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
