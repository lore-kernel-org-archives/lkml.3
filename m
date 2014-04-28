Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaD1K0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:26:46 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:58588 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbaD1K0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:26:43 -0400
Date: Mon, 28 Apr 2014 18:26:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Leilei Zhao <leilei.zhao@atmel.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas@eukrea.com,
        nicolas.ferre@atmel.com
Subject: Re: [PATCH 0/2] crypto: atmel-aes: fixes on block size of aes cfb
 mode
Message-ID: <20140428102634.GD17037@gondor.apana.org.au>
References: <1398151404-23408-1-git-send-email-leilei.zhao@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398151404-23408-1-git-send-email-leilei.zhao@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:23:22PM +0800, Leilei Zhao wrote:
> Hi:
> 
> These two patches correct the block size in atmel-aes driver while processing cfb8 and cfb64 mode of aes.

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
