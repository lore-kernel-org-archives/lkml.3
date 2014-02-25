Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaBYLup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:50:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39854 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBYLuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:50:44 -0500
Date: Tue, 25 Feb 2014 11:50:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
Message-ID: <20140225115036.GF13246@lee--X1>
References: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
 <20140225085701.GD19099@lee--X1>
 <24DF37198A1E704D9811D8F72B87EB51BCFDB5D2@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51BCFDB5D2@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Add support for a new BC variant of the DA9053 PMIC.
> > > There is one difference between it and the AA, BA and BB.
> > > This patch also corrects a typing mistake in one of the BA name
> > > strings that was incorrectly typed as "ab".
> > > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > > ---
> > >
> > > This patch is relative to linux-next repository tag next-20140219
> > 
> > That's not generally a good idea.
> > Please use a Mainline version (inc. -rcs).
> 
> Hi Lee,
> 
> thanks for applying the patch.
> 
> I can rebase against any tagged version in a public git repository, but in the past
> I was advised to use linux-next instead of the mainline. At this moment in time
> the latest tag in git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> is 'v3.14-rc4'
> 
> Are you recommending that tag as the one to rebase (and test of course) against?

I am. The trouble with basing your patches against -next is that it's
not stable, in that it is rebuilt every day. If your patches are
dependant on commits which haven't reached Mainline yet, then you
should rebase on the subsystem tree which they are contained in. All
patches in -next should be based on an -rc or a released kernel version.

> > > This patch depends on patch number 1 of this patch series being
> > > applied first or it will not compile.
> > >
> > >  drivers/mfd/da9052-i2c.c |    5 ++++-
> > >  drivers/mfd/da9052-spi.c |    1 +
> > >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > Applied, thanks.
> > 

--
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
