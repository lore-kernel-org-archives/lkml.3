Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbbAZCzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:55:32 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44468 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbAZCza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:55:30 -0500
Date: Mon, 26 Jan 2015 13:55:19 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel: Free memory in error path
Message-ID: <20150126025519.GA19796@gondor.apana.org.au>
References: <1421738152-30462-1-git-send-email-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421738152-30462-1-git-send-email-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 08:15:52AM +0100, Christophe Jaillet wrote:
> If only one of the 2 __get_free_pages fails, then there is a memory leak.
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
