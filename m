Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701AbaH0NkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:40:13 -0400
Received: from mail.eperm.de ([89.247.134.16]:46966 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933802AbaH0NkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:40:11 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DRBG: fix maximum value checks on 32 bit systems
Date: Wed, 27 Aug 2014 15:40:06 +0200
Message-ID: <12812557.76Zd8kO297@tauon>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140827133528.GA15871@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au> <1471416.zGlxQVbHUr@myon.chronox.de> <20140827133528.GA15871@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 27. August 2014, 21:35:28 schrieb Herbert Xu:

Hi Herbert,

>On Tue, Aug 26, 2014 at 11:36:54AM +0200, Stephan Mueller wrote:
>> The max_addtllen and max_req are defined in drbg_cores[] in
>> crypto/drbg.c for each DRBG type. As size_t on a 32 bit system is 32
>> bit the bit shifts would not work either.
>> 
>> Thus, I am wondering whether the just applied patch would need to go
>> to Linus
>> tree too? I would think that the following patch would be in order:
>Have you actually tested this on a 32-bit box? If so and it
>actually works then I'd be happy to push it.

I will have it tested by tomorrow.
>
>Cheers,


Ciao
Stephan
