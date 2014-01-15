Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaAODmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 22:42:40 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:34005 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaAODmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 22:42:38 -0500
Date: Wed, 15 Jan 2014 11:42:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] crypto: ccp - more code fixes/cleanup
Message-ID: <20140115034230.GA13556@gondor.apana.org.au>
References: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:33:53PM -0600, Tom Lendacky wrote:
> The following series implements a fix to hash length wrapping as well
> as some additional fixes and cleanups (proper gfp_t type on some memory
> allocations, scatterlist usage improvements, null request result field
> checks and driver enabled/disabled changes).
> 
> This patch series is based on the cryptodev-2.6 kernel tree.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
