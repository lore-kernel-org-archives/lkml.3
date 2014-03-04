Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaCDCCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:02:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55230 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbaCDCCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:02:33 -0500
Message-ID: <1393898546.10148.19.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 4/8] evm: EVM does not use MD5
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
        linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com
Date: Mon, 03 Mar 2014 21:02:26 -0500
In-Reply-To: <e0a79642b9e1ab8c63ea5a7a7af93fc319e366b0.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	 <e0a79642b9e1ab8c63ea5a7a7af93fc319e366b0.1393599538.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030402-0928-0000-0000-0000001C5705
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote: 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Missing patch description ...

Mimi 
> ---
>  security/integrity/evm/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
> index fea9749..5aa9103 100644
> --- a/security/integrity/evm/Kconfig
> +++ b/security/integrity/evm/Kconfig
> @@ -2,7 +2,6 @@ config EVM
>  	boolean "EVM support"
>  	depends on SECURITY && KEYS && (TRUSTED_KEYS=y || TRUSTED_KEYS=n)
>  	select CRYPTO_HMAC
> -	select CRYPTO_MD5
>  	select CRYPTO_SHA1
>  	select ENCRYPTED_KEYS
>  	default n


