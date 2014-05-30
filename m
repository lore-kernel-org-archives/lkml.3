Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaE3Kwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:52:39 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:49608 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaE3Kwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:52:37 -0400
Date: Fri, 30 May 2014 18:52:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com, joe@perches.com
Subject: Re: [PATCH v7 0/6] SP800-90A Deterministic Random Bit Generator
Message-ID: <20140530105232.GA13413@gondor.apana.org.au>
References: <20140523211459.GA21019@gondor.apana.org.au>
 <1449817.RiX7azh5Ri@myon.chronox.de>
 <20140530090548.GA12603@gondor.apana.org.au>
 <1743692.XvreuYbNlX@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1743692.XvreuYbNlX@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 12:08:08PM +0200, Stephan Mueller wrote:
>> > We already have a user-space interface to change priorities.
> 
> Great -- if I may ask, which interface is that?

Take a look at crypto/crypto_user.c

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
