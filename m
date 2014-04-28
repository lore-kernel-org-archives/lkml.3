Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaD1ISR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:18:17 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:58995 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaD1ISN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:18:13 -0400
Date: Mon, 28 Apr 2014 16:18:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-arm-msm@vger.kernel.org,
        Mona Hossain <mhossain@codeaurora.org>,
        Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
        Zhen Kong <zkong@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/9] crypto: qce: Add ablkcipher algorithms
Message-ID: <20140428081805.GA15980@gondor.apana.org.au>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
 <1397479725-20954-5-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397479725-20954-5-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 03:48:40PM +0300, Stanimir Varbanov wrote:
>
> +	} else if (IS_DES(flags)) {
> +		u32 tmp[DES_EXPKEY_WORDS];
> +
> +		if (keylen != QCE_DES_KEY_SIZE)
> +			goto badkey;

No need to check here since you've already set min_keysize and
max_keysize correctly.

> +	} else if (IS_3DES(flags)) {
> +		if (keylen != DES3_EDE_KEY_SIZE)
> +			goto badkey;

Ditto.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
