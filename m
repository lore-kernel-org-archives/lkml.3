Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3CUKTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:19:22 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:59685 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752870Ab3CUKTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:19:20 -0400
X-Greylist: delayed 1484 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Mar 2013 06:19:20 EDT
Date: Thu, 21 Mar 2013 18:19:13 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-ide <linux-ide@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 3/8] drivers: char: use
 module_platform_driver_probe()
Message-ID: <20130321101912.GA27199@gondor.apana.org.au>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
 <1363280978-24051-4-git-send-email-fabio.porcedda@gmail.com>
 <20130321095542.GH26931@gondor.apana.org.au>
 <CAHkwnC_AJpeVw2o8oJn+zMvSg1Lbmm1aXRYxCmtDYhkJG9nvig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkwnC_AJpeVw2o8oJn+zMvSg1Lbmm1aXRYxCmtDYhkJG9nvig@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:15:26AM +0100, Fabio Porcedda wrote:
> On Thu, Mar 21, 2013 at 10:55 AM, Herbert Xu
> <herbert@gondor.apana.org.au> wrote:
> > On Thu, Mar 14, 2013 at 06:09:33PM +0100, Fabio Porcedda wrote:
> >> This patch converts the drivers to use the
> >> module_platform_driver_probe() macro which makes the code smaller and
> >> a bit simpler.
> >>
> >> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Matt Mackall <mpm@selenic.com>
> >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> >> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> >
> > Patch applied.
> 
> The patch is already in
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git.
> Are you speaking about that?

OK, I'll remove it from my tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
