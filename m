Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaIJIY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:24:26 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56271 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaIJIYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:24:23 -0400
X-Originating-IP: 107.170.219.250
Date: Wed, 10 Sep 2014 01:24:16 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org,
        Build bot for Mark Brown <broonie@kernel.org>,
        kernel-build-reports@lists.linaro.org, Felix Fietkau <nbd@openwrt.org>,
        Imre Kaloz <kaloz@openwrt.org>, linux-kernel@vger.kernel.org
Subject: CNS3xxx maintainer (was Re: master build: 0 failures 28 warnings
 (v3.17-rc4-158-ge874a5f))
Message-ID: <20140910082416.GA31925@d1stkfactory>
References: <E1XRaM1-0006oX-7W@cassiel.sirena.org.uk>
 <3041301.pUTzAnrqpK@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3041301.pUTzAnrqpK@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:01:43AM +0200, Arnd Bergmann wrote:
[...]
> > -------------------------------------------------------------------------------
> > arm-allmodconfig : PASS, 0 errors, 18 warnings, 0 section mismatches
> > 
> > Warnings:
> > 	../arch/arm/mach-cns3xxx/pcie.c:311:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> I guess we should try to find a new cns3xxx maintainer

I'd be more than happy to hand it over. As far as I know, OpenWRT is a
major user of cns3xxx nowadays, so Cc'ing some of the active folks.

> Anton no longer has access to the hardware as far as I know,

Yup.

> and the patch I made for this needs to be tested.

Fwiw, it looked really good.

Thanks!

Anton
