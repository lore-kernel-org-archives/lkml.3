Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3KRVvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:51:43 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42628 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3KRVvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:51:39 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH v2 2/3] hwrng: OMAP3 ROM Random Number Generator support
Date: Mon, 18 Nov 2013 22:51:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Matt Mackall <mpm@selenic.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com> <20131008190408.GM8313@atomide.com> <20131016125734.GA10906@gondor.apana.org.au>
In-Reply-To: <20131016125734.GA10906@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201311182251.35704@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 October 2013 14:57:34 Herbert Xu wrote:
> On Tue, Oct 08, 2013 at 12:04:09PM -0700, Tony Lindgren wrote:
> > * Pali Rohár <pali.rohar@gmail.com> [130920 06:33]:
> > > This driver provides kernel-side support for the Random
> > > Number Generator hardware found on OMAP34xx processors.
> > > 
> > > This driver comes from Maemo 2.6.28 kernel and was tested
> > > on Nokia RX-51. It is platform device because it needs
> > > board specific function for smc calls.
> > 
> > This one is should be merged via the hw_random patches
> > seprately:
> > 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Patch applied.  Thanks!

Hello, I still do not see this patch (2/3) in linus tree. But 
patch 1/3 and 3/3 are already merged. So is there any problem?

-- 
Pali Rohár
pali.rohar@gmail.com
