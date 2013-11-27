Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3K0RT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:19:59 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51477 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab3K0RT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:19:57 -0500
Date: Wed, 27 Nov 2013 12:19:52 -0500
From: Matt Porter <matt.porter@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v3 7/9] phy: add Broadcom Kona USB2 PHY DT binding
Message-ID: <20131127171952.GF31091@beef>
References: <1385403367-18144-1-git-send-email-matt.porter@linaro.org>
 <1385403367-18144-8-git-send-email-matt.porter@linaro.org>
 <52947869.4040101@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52947869.4040101@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 04:01:05PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Monday 25 November 2013 11:46 PM, Matt Porter wrote:
> > Add a binding that describes the Broadcom Kona USB2 PHY found
> > on the BCM281xx family of SoCs.
> > 
> > Signed-off-by: Matt Porter <matt.porter@linaro.org>
> > ---
> >  .../devicetree/bindings/phy/bcm-kona-usb2-phy.txt         | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt b/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
> > new file mode 100644
> > index 0000000..3dc8b3d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
> 
> you should name this bcm-phy. Then you can add binding info of all (future) PHY
> IP from broadcom here.
> 
> other than that this looks fine..

Ok, sounds reasonable. I've noticed that convention with the TI USB
bindings...I'll do the same.

> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> Thanks
> Kishon
