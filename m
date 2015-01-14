Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbbANJqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:46:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59078 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbbANJqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:46:45 -0500
Date: Wed, 14 Jan 2015 04:46:31 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: "'Herbert Xu'" <herbert@gondor.apana.org.au>,
        Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 0/2] crypto: AF_ALG: add AEAD and RNG support
Message-ID: <20150114094631.GB15294@localhost.localdomain>
References: <5489736.JvWhZNrmuD@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5489736.JvWhZNrmuD@tachyon.chronox.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 04:52:29AM +0100, Stephan Mueller wrote:
> Hi,
> 
> This patch set adds AEAD and RNG support to the AF_ALG interface
> exported by the kernel crypto API. By extending AF_ALG with AEAD and RNG
> support, all cipher types the kernel crypto API allows access to are
> now accessible from userspace.
> 
>  crypto/Kconfig      |   9 +
>  crypto/Makefile     |   1 +
>  crypto/algif_aead.c | 680 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 690 insertions(+)
>  create mode 100644 crypto/algif_aead.c
> 
> -- 
> 2.1.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Where are the RNG bits?
Neil

