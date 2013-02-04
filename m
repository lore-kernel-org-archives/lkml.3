Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3BDNWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:22:18 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:35809 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753858Ab3BDNWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:22:16 -0500
Date: Mon, 4 Feb 2013 21:21:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Vakul Garg <vakul@freescale.com>
Cc: linux-crypto@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] crypto: caam - Added property fsl,sec-era in SEC4.0
 device tree binding.
Message-ID: <20130204132156.GC21627@gondor.apana.org.au>
References: <1359009826-32483-1-git-send-email-vakul@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359009826-32483-1-git-send-email-vakul@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 12:13:46PM +0530, Vakul Garg wrote:
> This new property defines the era of the particular SEC version.
> The compatible property in device tree "crypto" node has been updated
> not to contain SEC era numbers.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
