Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3ENCgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:36:07 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:52625 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756112Ab3ENCgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:36:03 -0400
Date: Tue, 14 May 2013 10:35:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: crypto: use devm_ioremap_resource()
Message-ID: <20130514023557.GC19306@gondor.apana.org.au>
References: <1367496038-4038-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367496038-4038-1-git-send-email-laurent.navet@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 02:00:38PM +0200, Laurent Navet wrote:
> Replace calls to deprecated devm_request_and_ioremap by devm_ioremap_resource.
> 
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_request_and_ioremap.cocci.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
