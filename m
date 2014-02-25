Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaBYMTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:19:18 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:53534 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaBYMTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:19:17 -0500
Date: Tue, 25 Feb 2014 20:19:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: ccp - minor code fixes
Message-ID: <20140225121911.GJ12216@gondor.apana.org.au>
References: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 08:41:56AM -0600, Tom Lendacky wrote:
> The following series implements some fixes to some code paths executed
> during crypto API request processing.  These fixes address processing of
> requests when the CCP driver returns -EBUSY and freeing memory in error
> paths.
> 
> This patch series is based on the cryptodev-2.6 kernel tree.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
