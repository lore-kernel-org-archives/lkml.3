Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaLGJ2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 04:28:42 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:48684 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaLGJ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 04:28:39 -0500
Date: Sun, 7 Dec 2014 17:28:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: George Spelvin <linux@horizon.com>
Cc: dborkman@redhat.com, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tgraf@suug.ch
Subject: Re: Where exactly will arch_fast_hash be used
Message-ID: <20141207092828.GA8623@gondor.apana.org.au>
References: <20141207052041.20498.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141207052041.20498.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 12:20:41AM -0500, George Spelvin wrote:
>
> Can you point me to a source for that statement?

For a start why don't you print out the hashes of 1-255 and then
find out how easy it is to deduce the last bit of the hash result.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
