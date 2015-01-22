Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbbAVWXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:23:15 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59393 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbbAVWXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:23:11 -0500
Date: Fri, 23 Jan 2015 09:23:03 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Message-ID: <20150122222302.GA10895@gondor.apana.org.au>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
 <20150120031704.GB10475@gondor.apana.org.au>
 <40625395.stBBYbAQtz@tachyon.chronox.de>
 <54C1403D.1010608@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C1403D.1010608@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:23:57AM -0800, Tadeusz Struk wrote:
>
> No, I thought that the agreement was that we don't want to allow user
> space to use these helpers directly, right? Am I missing something?

Yes but we should also fix this so that it's a proper aead
algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
