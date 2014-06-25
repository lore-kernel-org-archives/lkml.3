Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbaFYNsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:48:37 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:50660 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165AbaFYNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:48:35 -0400
Date: Wed, 25 Jun 2014 21:48:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, alexandru.porosanu@freescale.com,
        kim.phillips@freescale.com, dan.carpenter@oracle.com
Subject: Re: [PATCH] crypto: caam - Add definition of rd/wr_reg64 for little
 endian platform
Message-ID: <20140625134831.GC10379@gondor.apana.org.au>
References: <1403529570-23393-1-git-send-email-ruchika.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403529570-23393-1-git-send-email-ruchika.gupta@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:49:30PM +0530, Ruchika Gupta wrote:
> CAAM IP has certain 64 bit registers . 32 bit architectures cannot force
> atomic-64 operations.  This patch adds definition of these atomic-64
> operations for little endian platforms. The definitions which existed
> previously were for big endian platforms.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
