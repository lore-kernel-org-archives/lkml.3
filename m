Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3ILF2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:28:16 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:42567 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346Ab3ILF2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:28:15 -0400
Date: Thu, 12 Sep 2013 15:28:06 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: andr345@gmail.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        arthur.marsh@internode.on.net, tim.c.chen@linux.intel.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
Message-ID: <20130912052806.GA15737@gondor.apana.org.au>
References: <1374283864.22432.393.camel@schen9-DESK>
 <20130720053021.GA19689@gondor.apana.org.au>
 <201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp>
 <201309112043.HBD04609.FOtLSOFVQHFOJM@I-love.SAKURA.ne.jp>
 <20130912042622.GA15181@gondor.apana.org.au>
 <201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:03:41PM +0900, Tetsuo Handa wrote:
> Herbert Xu wrote:
> > This way at least you'll have a working system until your initramfs
> > tool is fixed to do the right thing.
> 
> Thank you. But it is module-init-tools-3.9-21.el6_4 in RHEL 6.4.
> We can't wait until Red Hat backports module-init-tools >= 3.11 to RHEL 6.x.
> 
> Since most people are already using module-init-tools >= 3.11 and
> there is workaround for my case (i.e. choose built-in), just updating
> 
>   module-init-tools      0.9.10                  # depmod -V
> 
> line at "Current Minimal Requirements" in Documentation/Changes will be OK.

The trouble is not all distros will include the softdep modules in
the initramfs.  So for now I think we will have to live with a fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
