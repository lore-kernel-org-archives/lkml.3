Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaJNUAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:00:41 -0400
Received: from mail.eperm.de ([89.247.134.16]:54065 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbaJNUAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:00:39 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel crypto API interface specification
Date: Tue, 14 Oct 2014 22:00:37 +0200
Message-ID: <2178720.yAoRcDWDgu@myon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.16.4-200.fc20.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <7502136.9BkWHTZ0th@myon.chronox.de>
References: <7502136.9BkWHTZ0th@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. Oktober 2014, 21:46:50 schrieb Stephan Mueller:

Hi,

> The update adds a complete interface documentation of the kernel crypto
> API. All cipher types supported by the kernel crypto API are documented.
> 
> In addition, kernel and user space example code is provided. The sample
> code covers synchronous and asynchronous cipher operation, random
> number generation and performing hashing as well as encryption and
> decryption in user space.

I was not sure whether to cover the explanation of the API in a separate 
document or whether to add the function documentation to 
include/linux/crypto.h.

With the first attempt of the documentation, I applied the least invasive 
approach. If it is requested, I would modify the patch such that appropriate 
source code comments to the functions in the header file are added.

-- 
Ciao
Stephan
