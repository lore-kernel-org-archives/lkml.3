Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbaJXOz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:55:56 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:41606 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaJXOzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:55:55 -0400
Date: Fri, 24 Oct 2014 22:55:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Matt Mackall <mpm@selenic.com>, Torsten Duwe <duwe@lst.de>,
        Jason Cooper <jason@lakedaemon.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Amit Shah <amit.shah@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] char: hw_random: core.c:  Changed from using strncat
 to strlcat
Message-ID: <20141024145517.GF21055@gondor.apana.org.au>
References: <1413494243-30867-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413494243-30867-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:17:23PM +0200, Rickard Strandqvist wrote:
> The buf is used to hold the list of hwrng devices registered.
> The old code ensures we don't walk off the end of buf as we
> fill it, but it's unnecessarily complicated and thus difficult
> to maintain. Simplify it by using strlcat.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
