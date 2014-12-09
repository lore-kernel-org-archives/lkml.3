Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaLIOZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:25:50 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59105 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaLIOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:25:48 -0500
Date: Tue, 9 Dec 2014 22:24:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: George Spelvin <linux@horizon.com>
Cc: davem@davemloft.net, dborkman@redhat.com, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tgraf@suug.ch,
        tytso@mit.edu
Subject: Re: Where exactly will arch_fast_hash be used
Message-ID: <20141209142423.GB9745@gondor.apana.org.au>
References: <20141207125157.GA9745@gondor.apana.org.au>
 <20141207132305.24691.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141207132305.24691.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 08:23:05AM -0500, George Spelvin wrote:
>
> Okay, I'm confused.  *What* scheme?  The arch_fast_hash interface doesn't
> have any provision for a secret.  Because there's no point to having one;

It does actually, in the form of the seed parameter.  That's why
it's so bad: it pretends to be a semi-secure hash function that
people will use in hash tables.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
