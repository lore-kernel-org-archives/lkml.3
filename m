Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3IYKNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:13:06 -0400
Received: from 8bytes.org ([85.214.48.195]:47207 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab3IYKNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:13:04 -0400
Date: Wed, 25 Sep 2013 12:13:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: integrator: Make sure INTEGRATOR_AP depends on PCI
Message-ID: <20130925101301.GZ20372@8bytes.org>
References: <1376509818-22163-1-git-send-email-joro@8bytes.org>
 <20130814195701.GY23006@n2100.arm.linux.org.uk>
 <20130814200442.GA20372@8bytes.org>
 <CACRpkdZVAG=0zvLbR4E+UEjHUaYOgqUxsfGoZybPtm1DwDAJ1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZVAG=0zvLbR4E+UEjHUaYOgqUxsfGoZybPtm1DwDAJ1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 25 12:13:03 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5242b72f20861458263084
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 09:26:57AM +0200, Linus Walleij wrote:
> Yes.
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> And can you please create and send a proper patch with this
> content to arm@kernel.org and the mailing list on CC, with
> a request for the ARM SoC maintainers to apply it directly
> as a fix?
> 
> You might as well add Cc: stable@vger.kernel.org as well.

Okay, sorry, forgot about this one. But my compile-tests kindly reminded
me and I sent the patch out again now :)


	Joerg


