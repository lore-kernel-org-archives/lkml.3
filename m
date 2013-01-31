Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3AaJfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:35:23 -0500
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:49844 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3AaJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:35:20 -0500
Message-ID: <20130131113516.96632or3s6s22bwg@www.dalek.fi>
Date: Thu, 31 Jan 2013 11:35:16 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tom St Denis <tstdenis@elliptictech.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues,
 indent, and testmgr build issues
References: <20130124094337.GJ9147@secunet.com>
 <20130124112410.8535.75598.stgit@localhost6.localdomain6>
 <20130129093331.GA23291@secunet.com>
In-Reply-To: <20130129093331.GA23291@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Steffen Klassert <steffen.klassert@secunet.com>:

> On Thu, Jan 24, 2013 at 01:25:46PM +0200, Jussi Kivilinna wrote:
>>
>> Maybe it would be cleaner to not mess with pfkeyv2.h at all, but  
>> instead mark algorithms that do not support pfkey with flag. See  
>> patch below.
>>
>
> As nobody seems to have another opinion, we could go either with your
> approach, or we can invert the logic and mark all existing algorithms
> as pfkey supported. Then we would not need to bother about pfkey again.
>
> I'd be fine with both. Do you want to submit a patch?
>

Ok, I'll invert the logic and send new patch.

-Jussi



