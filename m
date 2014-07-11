Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaGKJdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:33:33 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:46740 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGKJdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:33:31 -0400
Date: Fri, 11 Jul 2014 10:33:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon <kishon@ti.com>, "kernel@stlinux.com" <kernel@stlinux.com>
Subject: Re: [PATCH v3 2/5] phy: miphy365x: Add MiPHY365x header file for DT
 x Driver defines
Message-ID: <20140711093325.GB30519@lee--X1>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
 <1404906074-31992-3-git-send-email-lee.jones@linaro.org>
 <CAG374jD=DOVveEOxvddxMZYrEk0Paj4on3cnzSM8kZstSUrwcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG374jD=DOVveEOxvddxMZYrEk0Paj4on3cnzSM8kZstSUrwcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Gabriel Fernandez wrote:

> Hi Lee
> 
> On 9 July 2014 13:41, Lee Jones <lee.jones@linaro.org> wrote:
> > This provides the shared header file which will be reference from both
> > the MiPHY365x driver and its associated Device Tree node(s).
> >
> > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  include/dt-bindings/phy/phy-miphy365x.h | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >  create mode 100644 include/dt-bindings/phy/phy-miphy365x.h
> >
> > diff --git a/include/dt-bindings/phy/phy-miphy365x.h b/include/dt-bindings/phy/phy-miphy365x.h
> > new file mode 100644
> > index 0000000..8ef8aba
> > --- /dev/null
> > +++ b/include/dt-bindings/phy/phy-miphy365x.h
> > @@ -0,0 +1,14 @@
> > +/*
> > + * This header provides constants for the phy framework
> > + * based on the STMicroelectronics MiPHY365x.
> > + *
> > + * Author: Lee Jones <lee.jones@linaro.org>
> > + */
> > +#ifndef _DT_BINDINGS_PHY_MIPHY
> > +#define _DT_BINDINGS_PHY_MIPHY
> > +
> > +#define MIPHY_TYPE_SATA                1
> 
> why it start to 1 ? for my side i prefer 0.

Because 0 is a default state after using devm_kzalloc(), meaning
'unset', which would be an error.

> > +#define MIPHY_TYPE_PCIE                2
> > +#define MIPHY_TYPE_USB         3
> > +
> > +#endif /* _DT_BINDINGS_PHY_MIPHY */
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
