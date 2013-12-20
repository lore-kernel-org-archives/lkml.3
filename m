Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab3LTOHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:07:32 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:45349 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab3LTOHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:07:31 -0500
Date: Fri, 20 Dec 2013 22:07:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: ccp - code fixes/cleanup
Message-ID: <20131220140724.GA356@gondor.apana.org.au>
References: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:38:27AM -0600, Tom Lendacky wrote:
> The following series implements fixes and cleanup for some reported
> errors and suggestions (sparse errors, randconfig build errors and
> pr_err usage).
> 
> This patch series is based on the cryptodev-2.6 kernel tree.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
