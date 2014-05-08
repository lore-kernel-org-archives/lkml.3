Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaEHOB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:01:58 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:40717 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbaEHOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:01:56 -0400
Date: Thu, 8 May 2014 22:01:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Michael Buesch'" <m@bues.ch>,
        "'Lokesh Vutla'" <lokeshvutla@ti.com>
Subject: Re: [PATCH 1/2] hwrng: omap - remove unnecessary OOM messages
Message-ID: <20140508140152.GD13769@gondor.apana.org.au>
References: <002201cf6383$3307d290$991777b0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002201cf6383$3307d290$991777b0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:15:36PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
