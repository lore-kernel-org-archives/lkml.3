Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaBMMXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:23:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36514 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257AbaBMMXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:23:49 -0500
Date: Thu, 13 Feb 2014 12:23:17 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
Message-ID: <20140213122317.GC5871@e106331-lin.cambridge.arm.com>
References: <1392220985-28189-1-git-send-email-lee.jones@linaro.org>
 <20140212164019.GE25957@e106331-lin.cambridge.arm.com>
 <20140213110314.GH32508@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213110314.GH32508@lee--X1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:03:14AM +0000, Lee Jones wrote:
> > > The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> > > devices. It has 2 ports which it can use for either; both SATA, both
> > > PCIe or one of each in any configuration.
> > > 
> > > Cc: devicetree@vger.kernel.org
> > > Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  .../devicetree/bindings/phy/phy-miphy365x.txt      | 43 ++++++++++++++++++++++
> > >  1 file changed, 43 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> > > new file mode 100644
> > > index 0000000..fdfa7ca
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> > > @@ -0,0 +1,43 @@
> > > +STMicroelectronics STi MIPHY365x PHY binding
> > > +============================================
> > > +
> > > +This binding describes a miphy device that is used to control PHY hardware
> > > +for SATA and PCIe.
> > > +
> > > +Required properties:
> > > +- compatible: Should be "st,miphy365x-phy"
> > > +- #phy-cells: Should be 2 (See example)
> > 
> > The first example has #phy-cells = <1>.
> 
> Right, will fix. Should be 2.
> 
> > What do the cells mean? What are the expected values?
> 
> http://www.spinics.net/lists/arm-kernel/msg307209.html

Ok. Could that be mentioned in the binding document then?

Cheers,
Mark.
