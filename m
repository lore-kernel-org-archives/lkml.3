Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120Ab3CHAyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:54:53 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:1798 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760077Ab3CHAyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:54:51 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Thu, 7 Mar 2013 18:51:27 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - fix typo "CRYPTO_AHASH"
Message-ID: <20130307185127.a525f832276be2b30153aedf@freescale.com>
In-Reply-To: <1362490396.16460.87.camel@x61.thuisdomein>
References: <1362490396.16460.87.camel@x61.thuisdomein>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Mar 2013 14:33:16 +0100
Paul Bolle <pebolle@tiscali.nl> wrote:

> The Kconfig entry for CAAM's hash algorithm implementations has always
> selected CRYPTO_AHASH. But there's no corresponding Kconfig symbol.
> 
> It seems it was intended to select CRYPTO_HASH, like other crypto
> drivers do. That would apparently (indirectly) select CRYPTO_HASH2,
> which would enable the ahash functionality this driver uses.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---

Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Kim

