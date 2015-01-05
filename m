Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbbAEKhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:37:34 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35485 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbbAEKhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:37:31 -0500
Date: Mon, 5 Jan 2015 21:37:22 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: amcc: crypto4xx_sa.c:  Remove unused function
Message-ID: <20150105103722.GC25200@gondor.apana.org.au>
References: <1420125228-26679-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420125228-26679-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 04:13:47PM +0100, Rickard Strandqvist wrote:
> Remove the function get_dynamic_sa_offset_iv_field() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
