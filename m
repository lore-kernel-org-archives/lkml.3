Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3CUKhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:37:24 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:37346 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754345Ab3CUKhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:37:21 -0400
Date: Thu, 21 Mar 2013 17:54:16 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
        linus.walleij@linaro.org, andreas.westin@stericsson.com, arnd@arndb.de,
        rubini@unipv.it, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: replace kmalloc and then memcpy with kmemdup
Message-ID: <20130321095415.GB26931@gondor.apana.org.au>
References: <1362998890-7532-1-git-send-email-mihneadb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362998890-7532-1-git-send-email-mihneadb@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:48:10PM +0200, Mihnea Dobrescu-Balaur wrote:
> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
