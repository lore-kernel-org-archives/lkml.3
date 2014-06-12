Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbaFLKCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:02:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851AbaFLKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:02:03 -0400
Subject: Re: [PATCH] phy: Fix typo in drivers/phy/phy-exynos5250-sata.c
 module which fixes the build
From: Jean Delvare <jdelvare@suse.de>
To: guillaume.gardet@free.fr
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org,
        openSUSE Kernel ML <opensuse-kernel@opensuse.org>,
        Girish K S <ks.giri@samsung.com>, Yuvaraj C D <yuvaraj.cd@samsung.com>,
        Sachin Kamat <spk.linux@gmail.com>
In-Reply-To: <53997666.7000003@free.fr>
References: <53996247.5020203@free.fr>
	 <CAK5sBcH-6xeKomVay4PFWzLV8M-Sx=jankcE-7mj7K00=Gwe4w@mail.gmail.com>
	 <53996852.1050708@free.fr> <53996CF9.5070100@ti.com>
	 <53997666.7000003@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Thu, 12 Jun 2014 12:01:59 +0200
Message-ID: <1402567319.4564.2.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thursday 12 June 2014 à 11:44 +0200, Guillaume Gardet a écrit :
> Le 12/06/2014 11:03, Kishon Vijay Abraham I a écrit :
> >
> > On Thursday 12 June 2014 02:14 PM, Guillaume Gardet wrote:
> >> Le 12/06/2014 10:36, Sachin Kamat a écrit :
> >>> Hi Guillaume,
> >>>
> >>>
> >>> On Thu, Jun 12, 2014 at 1:48 PM, Guillaume Gardet
> >>> <guillaume.gardet@free.fr> wrote:
> >>>> Hi,
> >>>>
> >>>> please find in attachment a patch which fixes a typo in drivers/phy/phy-exynos5250-sata.c module license.
> >>>> It fixes the following build error:
> >>>>     FATAL: modpost: GPL-incompatible module phy-exynos5250-sata.ko uses GPL-only symbol 'platform_driver_unregister'
> >>>>
> >>>> Please keep me in CC since I am not subscribed to the linux-kernel@vger.kernel.org ML.
> >>>>
> >>>> Signed-off-by: Guillaume GARDET <guillaume.gardet@opensuse.org>
> >>> A similar patch has already been submitted by Arnd. Please see below:
> >>> https://lkml.org/lkml/2014/3/15/40
> >> Was not aware of this one. Will it be merged? I can see that it was sent 3 months ago and got no answer apparently.
> > It's in mainline kernel already
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/phy/phy-exynos5250-sata.c?id=fe04e4297e6eab014a2cf152319b9f361df07faf
> 
> Ok. It is in mainline but not in 3.15.

And as it stands, it won't be, because stable@vger.kernel.org was not
Cc'd. "Typo" in the subject makes it sound like a trivial and minor
change. "Fix module loading" would probably have made it clearer that it
fixes a real issue.

Guillaume, if this bothers you, please write to stable@vger.kernel.org
and kindly ask them to consider including this commit in future stable
releases.

-- 
Jean Delvare
SUSE L3 Support

