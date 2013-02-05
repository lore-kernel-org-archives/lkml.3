Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3BEQb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:31:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3BEQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:31:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
Date: Tue, 5 Feb 2013 16:31:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
References: <1358891160-9534-1-git-send-email-robdclark@gmail.com> <201301222153.19580.arnd@arndb.de>
In-Reply-To: <201301222153.19580.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051631.40254.arnd@arndb.de>
X-Provags-ID: V02:K0:vK2heXzJcQF7khwKJ7bPegcP8jCGMtRhrpUGffnZg+a
 6jocTlFHEafDfx1L4eFVtJOUDh7esZ8jgkPZhGMUXmPO8muryf
 90kQd8W874htwmnPjSXQFBSJN429J61rNkPWblZ1RdOnCu7cty
 IuMf3kcuLm4LiHL4bp3tgbysVJ+CddNH2nlc37d8GNToHU7Gsy
 CX9rlwgW7EYCdcoBhuRrQLKQLn7QeOqYON3DMEYclOVB9nGc2l
 alI6TUGQ/+4uZycSYOcxUk78EocMSPt+Cbsqyx4OU8LL+qVnuD
 +r3iig3/pj8YwPK0Q1BRriGoAnSAVuWRL+w6+ZcxUe/5XQ5+ga
 1Ppnry1R0OH2kFM9gUcQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Arnd Bergmann wrote:
> On Tuesday 22 January 2013, Rob Clark wrote:
> > At least core omapdss does not have any build dependencies on
> > ARCH_OMAP2PLUS, and adding this dependency in the Kconfig breaks omapdrm
> > for ARCH_MULTIPLATFORM builds.
> > 
> > Signed-off-by: Rob Clark <robdclark@gmail.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

It seems nobody has applied this patch, as it has not shown up in
linux-next or upstream. Who should take care of this? If nobody feels
responsible, I can put it into arm-soc/fixes.

	Arnd
