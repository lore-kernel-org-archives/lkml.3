Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbaEVNJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:09:34 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:35617 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEVNJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:09:32 -0400
Date: Thu, 22 May 2014 21:09:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: Fix DMA-API warning
Message-ID: <20140522130924.GE3598@gondor.apana.org.au>
References: <20140519165133.GA3365@gitlad.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519165133.GA3365@gitlad.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 09:51:33AM -0700, Tadeusz Struk wrote:
> With DMA-API debug enabled testmgr triggers a "DMA-API: device driver maps memory from stack" warning, when tested on a crypto HW accelerator.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
