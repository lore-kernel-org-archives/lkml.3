Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaCEJMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:12:23 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57191 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaCEJMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:12:18 -0500
Date: Wed, 5 Mar 2014 17:12:12 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
Message-ID: <20140305091212.GA10380@lee--X1>
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
 <20140305073422.GD20016@e106331-lin.cambridge.arm.com>
 <20140305084039.GB14902@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140305084039.GB14902@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +Specifying phy control of devices
> > > +=================================
> > > +
> > > +Device nodes should specify the configuration required in their "phys"
> > > +property, containing a phandle to the miphy device node, a port number
> > > +and a device type.
> > > +
> > > +Example:
> > > +
> > > +#include <dt-bindings/phy/phy-miphy365x.h>
> > > +
> > > +	sata0: sata@fe380000 {
> > > +		...
> > > +		phys	  = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
> > > +		...
> > > +	};
> > 
> > Is there not a generic phy binding we can point to? It seems a bit
> > redundant to do this in each phy binding.
> 
> Sure, but that wouldn't make much of an example.
> 
>   Documentation/devicetree/bindings/phy/phy-bindings.txt

Ah sorry, I see what you mean now.

No, not yet. That's the next thing to go up into Mainline.

I will replace this second example with a link when the other
documentation document has been accepted.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
