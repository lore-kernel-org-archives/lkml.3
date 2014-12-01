Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaLAA6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:58:21 -0500
Received: from ozlabs.org ([103.22.144.67]:36412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaLAA6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:58:20 -0500
Message-ID: <1417395497.16178.0.camel@concordia>
Subject: Re: [PATCH 6/8 v2] crypto: replace memset by memzero_explicit
From: Michael Ellerman <mpe@ellerman.id.au>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Dec 2014 11:58:17 +1100
In-Reply-To: <1417367029-32762-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1417367029-32762-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1417367029-32762-7-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-30 at 18:03 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Memset on a local variable may be removed when it is called just before the
> variable goes out of scope.  Using memzero_explicit defeats this
> optimization.  A simplified version of the semantic patch that makes this
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Daniel Borkmann suggested that these patches could go through Herbert Xu's
> cryptodev tree.

That's fine by me:

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers


