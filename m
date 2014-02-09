Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaBIUSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:18:46 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56892 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbaBIUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:18:45 -0500
Message-ID: <1391977123.25855.24.camel@x220>
Subject: Re: [PATCH 05/28] Remove MPILIB_EXTRA
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:18:43 +0100
In-Reply-To: <1391971686-9517-6-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-6-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:18:44.0160 (UTC) FILETIME=[21745400:01CF25D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Paul Bolle <pebolle@tiscali.nl>

> ---
>  crypto/asymmetric_keys/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> index 03a6eb9..0320c7d 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -22,7 +22,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>  
>  config PUBLIC_KEY_ALGO_RSA
>  	tristate "RSA public-key algorithm"
> -	select MPILIB_EXTRA
>  	select MPILIB
>  	help
>  	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).

I tried this a year ago (see https://lkml.org/lkml/2013/3/8/142 ).


Paul Bolle

