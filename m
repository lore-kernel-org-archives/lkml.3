Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbbAHKsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:48:39 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:42727 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbbAHKsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:48:38 -0500
Date: Thu, 8 Jan 2015 21:48:28 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Asaf Vertz <asaf.vertz@tandemg.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: omap-des: fix BUG_ON condition
Message-ID: <20150108104827.GA8374@gondor.apana.org.au>
References: <20150105082310.GA19423@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105082310.GA19423@ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 10:23:10AM +0200, Asaf Vertz wrote:
> dd->total is unsigned so it won't do any good to check for negative value after subtracting
> instead of that we should check if the subtracted value is bigger than him
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
