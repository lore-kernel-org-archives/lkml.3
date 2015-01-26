Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbbAZC40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:56:26 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:48400 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbbAZC4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:56:22 -0500
Date: Mon, 26 Jan 2015 13:56:10 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "open list:AMD CRYPTOGRAPHIC..." <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp: terminate ccp_support array with empty
 element
Message-ID: <20150126025610.GF19796@gondor.apana.org.au>
References: <1421852791-29679-1-git-send-email-a.ryabinin@samsung.com>
 <54C264B1.5090508@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C264B1.5090508@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 09:11:45AM -0600, Tom Lendacky wrote:
> On 01/21/2015 09:06 AM, Andrey Ryabinin wrote:
> >x86_match_cpu() expects array of x86_cpu_ids terminated
> >with empty element.
> >
> >Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
