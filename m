Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304Ab3JPM5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:57:55 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:33083 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934239Ab3JPM5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:57:53 -0400
Date: Wed, 16 Oct 2013 20:57:48 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: mv_cesa: remove deprecated IRQF_DISABLED
Message-ID: <20131016125747.GB10906@gondor.apana.org.au>
References: <1381639753-7042-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381639753-7042-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 06:49:13AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
