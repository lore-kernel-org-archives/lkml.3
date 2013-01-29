Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3A2Jdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:33:39 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:46500 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3A2Jde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:33:34 -0500
Date: Tue, 29 Jan 2013 10:33:31 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tom St Denis <tstdenis@elliptictech.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent,
 and testmgr build issues
Message-ID: <20130129093331.GA23291@secunet.com>
References: <20130124094337.GJ9147@secunet.com>
 <20130124112410.8535.75598.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124112410.8535.75598.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 Jan 2013 09:33:31.0884 (UTC) FILETIME=[B3D1CAC0:01CDFE03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 01:25:46PM +0200, Jussi Kivilinna wrote:
> 
> Maybe it would be cleaner to not mess with pfkeyv2.h at all, but instead mark algorithms that do not support pfkey with flag. See patch below.
> 

As nobody seems to have another opinion, we could go either with your
approach, or we can invert the logic and mark all existing algorithms
as pfkey supported. Then we would not need to bother about pfkey again.

I'd be fine with both. Do you want to submit a patch?

