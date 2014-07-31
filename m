Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaGaT7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:59:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52223 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaGaT7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:59:49 -0400
Message-ID: <53DAA031.30405@amacapital.net>
Date: Thu, 31 Jul 2014 12:59:45 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Cristian Stoica <cristian.stoica@freescale.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
CC: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add TLS record layer encryption module
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
In-Reply-To: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 02:32 AM, Cristian Stoica wrote:
> Hi all,
> 
> This set of patches introduces support for TLS 1.0 record layer
> encryption/decryption with a corresponding algorithm called
> tls10(hmac(<hash>),cbc(<cipher>)).
> 
> Similarly to authenc.c on which it is based, this module mixes the base
> algorithms in software to produce an algorithm that does record layer
> encryption and decryption for TLS1.0.
> Any combination of hw and sw base algorithms is possible, but the purpose
> is to take advantage of hardware acceleration for TLS record layer offloading
> when hardware acceleration is present.

What is this used for?  AF_ALG?  I find it hard to believe that the
kernel will ever want to use this internally.

--Andy
