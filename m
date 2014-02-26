Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaBZV6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:58:32 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:41582 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBZV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:58:30 -0500
Date: Thu, 27 Feb 2014 05:58:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kumar Gala <galak@codeaurora.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the crypto tree with the arm-soc tree
Message-ID: <20140226215802.GA28350@gondor.apana.org.au>
References: <20140226150159.7ea5e60285ee9d0193bde811@canb.auug.org.au>
 <B4102448-9875-4C8A-94A1-E2EDFC5011E2@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B4102448-9875-4C8A-94A1-E2EDFC5011E2@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 01:15:06PM -0600, Kumar Gala wrote:
> 
> On Feb 25, 2014, at 10:01 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Herbert,
> > 
> > Today's linux-next merge of the crypto tree got a conflict in
> > drivers/char/hw_random/Kconfig between commit 2257ffbca73c ("hwrng: msm:
> > switch Kconfig to ARCH_QCOM depends") from the arm-soc tree and commit
> > f9bee046c915 ("hwrng: msm: switch Kconfig to ARCH_QCOM depends") from the
> > crypto tree.
> > 
> > Two version of the same patch ... I just kept the arm-soc version.
> 
> Herbert,
> 
> Was trying to keep all the ARCH_QCOM Kconfig updates together and via arm-soc.git

OK I have reverted this patch from cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
