Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaKTGcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:32:21 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:35937 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaKTGcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:32:17 -0500
Date: Thu, 20 Nov 2014 07:32:06 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Borkmann <dborkman@redhat.com>, <quentin.gouchet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher
 info
Message-ID: <20141120063206.GQ6390@secunet.com>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2688209.3bGZus2TD9@tachyon.chronox.de>
 <20141118140822.GB12100@gondor.apana.org.au>
 <16101836.sTaxopCThb@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <16101836.sTaxopCThb@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:03:24AM +0100, Stephan Mueller wrote:
> 
> Btw: is there an example that uses that interface? The ordering of data 
> structures in the netlink message is not really clear from looking at the 
> code.

I wrote to tool that uses this API some time ago, it is still
a bit rudimentary but should work. You can find it at:
https://sourceforge.net/projects/crconf/
