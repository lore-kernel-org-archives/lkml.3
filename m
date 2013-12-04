Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3LDNm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:42:29 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:52296
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab3LDNm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:42:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z579ehz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Wed, 4 Dec 2013 21:13:04 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <davidb@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: chipidea: msm: Add device tree binding
 information
Message-ID: <20131204131303.GB1573@shlinux1.ap.freescale.net>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
 <1384176937-1658-2-git-send-email-iivanov@mm-sol.com>
 <20131204054003.GB29552@shlinux1.ap.freescale.net>
 <1386146037.16040.13.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386146037.16040.13.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 10:33:57AM +0200, Ivan T. Ivanov wrote:
> Hi Peter, 
> 
> Thank you for reviewing this patch.
> 
> On Wed, 2013-12-04 at 13:40 +0800, Peter Chen wrote: 
> > On Mon, Nov 11, 2013 at 03:35:34PM +0200, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > 
> > 
> > Please add something in commit log
> > 
> > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > Cc: devicetree@vger.kernel.org
> > > ---
> > >  .../devicetree/bindings/usb/msm-hsusb.txt          |   16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > > index 5ea26c6..0a85eba 100644
> > > --- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > > +++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > > @@ -15,3 +15,19 @@ Example EHCI controller device node:
> > >  		usb-phy = <&usb_otg>;
> > >  	};
> > >  
> > > +CI13xxx (Chipidea) USB controllers
> > > +
> > 
> > We have already renamed ci13xxx to ci_hdrc.
> 
> Yes, but the chip is still CI13XXX. Freescale documentations is also 
> referring to actual chip family.

OK, let's keep IP reference at doc. I will change the Freescale doc
name from ci13xxx-imx.txt to ci-hdrc-imx.txt

> 
> > 
> > > +Required properties:
> > > +- compatible: 	should contain "qcom,ci-hdrc"
> > > +- reg: 			offset and length of the register set in the memory map
> > > +- interrupts: 	interrupt-specifier for the controller interrupt.
> > > +- usb-phy:		phandle for the PHY device
> > > +- dr_mode: 		Sould be "peripheral"
> > > +
> > 
> > Please keep alignment for "reg"
> > 
> 
> It looks aligned in editor with smart-tab support.
> 

OK, let's keep it

-- 

Best Regards,
Peter Chen

