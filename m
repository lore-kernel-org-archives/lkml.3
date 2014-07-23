Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaGWNL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:11:28 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:43071 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGWNL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:11:26 -0400
Date: Wed, 23 Jul 2014 21:10:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Kim Phillips <kim.phillips@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        linux-crypto@vger.kernel.org
Subject: Re: [RFC, prePATCH] crypto: talitos modified for powerpc 88x
 security engine
Message-ID: <20140723131048.GB29178@gondor.apana.org.au>
References: <20140711120939.DD0031A9740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711120939.DD0031A9740@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 02:09:39PM +0200, Christophe Leroy wrote:
> Here is a pre-patch for the support of the SEC ENGINE of MPC88x/MPC82xx
> I have tried to make use of defines in order to keep a single driver for the two
> TALITOS variants as suggested by Kim, but I'm not too happy about the quantity
> of #ifdef

Yeah these ifdefs have got to go.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
