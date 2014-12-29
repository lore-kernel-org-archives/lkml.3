Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaL2KUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:20:18 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:49851 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaL2KUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:20:15 -0500
Date: Mon, 29 Dec 2014 21:20:03 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v6 0/4] crypto: AF_ALG: add AEAD and RNG support
Message-ID: <20141229102002.GA13334@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5682082.ffPqvQlSqN@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 10:58:01PM +0100, Stephan Mueller wrote:
> Hi,
> 
> This patch set adds AEAD and RNG support to the AF_ALG interface
> exported by the kernel crypto API. By extending AF_ALG with AEAD and RNG
> support, all cipher types the kernel crypto API allows access to are
> now accessible from userspace.

For some reason your 1st patch came out last due to its Date
header.  Please fix this up in your next submission as otherwise
it screws up the patch ordering for me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
