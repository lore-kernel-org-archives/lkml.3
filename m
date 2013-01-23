Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3AWOgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:36:52 -0500
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:33744 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3AWOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:36:49 -0500
Message-ID: <20130123163644.19511ochn6jcqobo@www.81.fi>
Date: Wed, 23 Jan 2013 16:36:44 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues,
 indent, and testmgr build issues
References: <436404741.94502.1358773048618.JavaMail.root@elliptictech.com>
In-Reply-To: <436404741.94502.1358773048618.JavaMail.root@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tom St Denis <tstdenis@elliptictech.com>:

> Hey all,
>
> Here's an updated patch which addresses a couple of build issues and  
> coding style complaints.
>
> I still can't get it to run via testmgr I get
>
> [  162.407807] alg: No test for cmac(aes) (cmac(aes-generic))
>
> Despite the fact I have an entry for cmac(aes) (much like xcbc(aes)...).
>
> Here's the patch to bring 3.8-rc4 up with CMAC ...
>
> Signed-off-by: Tom St Denis <tstdenis@elliptictech.com>
>
<snip>
> diff --git a/include/uapi/linux/pfkeyv2.h b/include/uapi/linux/pfkeyv2.h
> index 0b80c80..d61898e 100644
> --- a/include/uapi/linux/pfkeyv2.h
> +++ b/include/uapi/linux/pfkeyv2.h
> @@ -296,6 +296,7 @@ struct sadb_x_kmaddress {
>  #define SADB_X_AALG_SHA2_512HMAC	7
>  #define SADB_X_AALG_RIPEMD160HMAC	8
>  #define SADB_X_AALG_AES_XCBC_MAC	9
> +#define SADB_X_AALG_AES_CMAC_MAC	10
>  #define SADB_X_AALG_NULL		251	/* kame */
>  #define SADB_AALG_MAX			251

Should these values be based on IANA assigned IPSEC AH transform identifiers?

https://www.iana.org/assignments/isakmp-registry/isakmp-registry.xml#isakmp-registry-6

-Jussi


