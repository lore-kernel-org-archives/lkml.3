Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3J3ELt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 00:11:49 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:35259 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751915Ab3J3ELr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 00:11:47 -0400
Date: Wed, 30 Oct 2013 12:11:44 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Joel Fernandes <joelf@ti.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: omap-aes: Fix CTR mode counter length
Message-ID: <20131030041143.GE2957@gondor.apana.org.au>
References: <1383086258-22186-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383086258-22186-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 05:37:38PM -0500, Joel Fernandes wrote:
> NIST vectors for CTR mode in testmgr.h assume the entire IV as the counter. To
> get correct results that match the output of these vectors, we need to set the
> counter length correctly.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
