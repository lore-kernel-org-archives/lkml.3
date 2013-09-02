Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab3IBKgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:36:14 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:43645 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758156Ab3IBKgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:36:13 -0400
Date: Mon, 2 Sep 2013 20:36:04 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwrng: via-rng: Add MODULE_DEVICE_TABLE
Message-ID: <20130902103604.GC815@gondor.apana.org.au>
References: <1378076037.25743.54.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378076037.25743.54.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 11:53:57PM +0100, Ben Hutchings wrote:
> via-rng currently isn't auto-loaded if built as a module.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
