Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbbAEKhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:37:39 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:36859 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbbAEKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:37:35 -0500
Date: Mon, 5 Jan 2015 21:37:31 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
        joe@perches.com
Subject: Re: [PATCH] crypto: Remove unnecessary KERN_ERR in bfin_crc.c
Message-ID: <20150105103730.GD25200@gondor.apana.org.au>
References: <1420170046-10269-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420170046-10269-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 12:40:46PM +0900, Masanari Iida wrote:
> This patch removes unnecessary KERN_ERR from bfin_crypto_crc_mod_init().
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
