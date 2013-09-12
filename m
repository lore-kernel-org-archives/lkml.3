Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3ILKaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:30:07 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:52487 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751831Ab3ILKaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:30:03 -0400
Date: Thu, 12 Sep 2013 20:29:53 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: andr345@gmail.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        arthur.marsh@internode.on.net, tim.c.chen@linux.intel.com,
        linux-crypto@vger.kernel.org
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
Message-ID: <20130912102953.GA18916@gondor.apana.org.au>
References: <201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp>
 <201309112043.HBD04609.FOtLSOFVQHFOJM@I-love.SAKURA.ne.jp>
 <20130912042622.GA15181@gondor.apana.org.au>
 <201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp>
 <20130912052806.GA15737@gondor.apana.org.au>
 <201309121920.AHJ58678.OMVJFFSHOtOFQL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309121920.AHJ58678.OMVJFFSHOtOFQL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 07:20:23PM +0900, Tetsuo Handa wrote:
> Herbert Xu wrote:
> > The trouble is not all distros will include the softdep modules in
> > the initramfs.  So for now I think we will have to live with a fallback.
> 
> I see.
> 
> Herbert Xu wrote:
> > OK, can you please try this patch on top of the current tree?
> > 
> > This way at least you'll have a working system until your initramfs
> > tool is fixed to do the right thing.
> 
> I tested the patch and confirmed that the boot failure was solved.
> 
> But arch/x86/crypto/crct10dif-pclmul.ko is not included into initramfs and
> therefore we cannot benefit from PCLMULQDQ version.

That is expected and is also the status quo.  So once the initrd
generation tool is fixed to include softdeps it will work properly.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
