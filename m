Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaGJJDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:03:25 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:54000 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaGJJDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:03:22 -0400
Date: Thu, 10 Jul 2014 17:03:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.16
Message-ID: <20140710090314.GA15729@gondor.apana.org.au>
References: <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203125944.GA31446@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes an error in sha512_ssse3 that leads to incorrect
output as well as a memory leak in caam_jr when the module is
unloaded.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Cristian Stoica (1):
      crypto: caam - fix memleak in caam_jr module

Jussi Kivilinna (1):
      crypto: sha512_ssse3 - fix byte count to bit count conversion

 arch/x86/crypto/sha512_ssse3_glue.c |    2 +-
 drivers/crypto/caam/jr.c            |    8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
