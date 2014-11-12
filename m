Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaKLRwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:52:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaKLRwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:52:16 -0500
Message-ID: <54639E3F.2010504@redhat.com>
Date: Wed, 12 Nov 2014 18:51:59 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] crypto: AF_ALG: add random number generator support
References: <4738444.A2vZX1nNCo@tachyon.chronox.de> <9137675.ZTbqvCU5Bi@tachyon.chronox.de> <5463978F.7020508@redhat.com> <26219337.yCCTlAE9Ns@tauon>
In-Reply-To: <26219337.yCCTlAE9Ns@tauon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 06:46 PM, Stephan Mueller wrote:
...
> * I unconditionally use the memset after memcpy as you indicated. Once
> the cryptodev tree contains the memzero_explicit call, I will start
> picking up that function.

Herbert merged it actually in this morning, so it's already part of
the cryptodev tree by now.

> Essentially, I throught of the line you suggested.

Ok, thanks.
