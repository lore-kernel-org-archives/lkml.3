Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaGUHkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:40:11 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:57354 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaGUHkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:40:05 -0400
Date: Mon, 21 Jul 2014 08:39:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@uda0393678>
Cc: linux-arm-kernel@lists.infrared.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, kernel@stlinux.com
Subject: Re: [PATCH v3 0/5] phy: miphy365x: Introduce support for MiPHY365x
Message-ID: <20140721073959.GR30888@lee--X1>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
 <20140721062805.GA8781@uda0393678>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140721062805.GA8781@uda0393678>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

> > This patchset is based on the two core patches you sent to the
> > list which facilitate creating PHYs residing on multi-channel
> > controllers.  The changes since the last submission centre
> > around dynamic PHY creation based solely on what is provided via
> > Device Tree, as requested.  The other review comments have also
> > been addressed in this set.
> 
> Merged the first four patches of this series. (merged v3+1 for 1st patch).
> I'm not sure who would be merging the dt patch (5/5). But for now I've merged
> 2/5 in linux-phy tree since the phy patch seems to be dependent on it.
> So the dt patch can be merged only after -rc1. However if whoever merges
> dt wants to get it merged during the merge window, I can prepare a common
> branch which both of us can merge to. Either ways, dt Maintainer should
> let me know.

Thanks for applying.  It would be really helpful if you could put just
patch 2/5 onto an immutable branch and provide a tag e that Maxime
could pull from.

Kind regards,
Lee

> >  .../devicetree/bindings/phy/phy-miphy365x.txt      |  76 +++
> >  arch/arm/boot/dts/stih416-b2020-revE.dts           |  10 +
> >  arch/arm/boot/dts/stih416-b2020.dts                |  12 +
> >  arch/arm/boot/dts/stih416.dtsi                     |  22 +
> >  drivers/phy/Kconfig                                |  10 +
> >  drivers/phy/Makefile                               |   1 +
> >  drivers/phy/phy-miphy365x.c                        | 636 +++++++++++++++++++++
> >  include/dt-bindings/phy/phy-miphy365x.h            |  14 +
> >  8 files changed, 781 insertions(+)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
