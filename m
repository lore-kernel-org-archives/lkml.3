Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaD1K0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:26:12 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:60335 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbaD1K0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:26:10 -0400
Date: Mon, 28 Apr 2014 18:25:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Cleanup ressource leaks in test_aead_speed()
Message-ID: <20140428102558.GC17037@gondor.apana.org.au>
References: <20140421204439.7999f1c6@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421204439.7999f1c6@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 08:44:39PM +0200, Christian Engelmayer wrote:
> This is a cleanup of Coverity ressource leak findings for the quick & dirty
> crypto testing module crypto/tcrypt.c.
> 
> All 3 changesets address function test_aead_speed() that was introduced in
> 53f52d7a (crypto: tcrypt - Added speed tests for AEAD crypto alogrithms in
> tcrypt test suite)

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
