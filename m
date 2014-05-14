Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaENVRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:17:46 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56144 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaENVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:17:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/gD1+sz82DkhpdEkZWtW0b
Date: Wed, 14 May 2014 14:17:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: kishon@ti.com, george.cherian@ti.com, balbi@ti.com, balajitk@ti.com,
        hdegoede@redhat.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Benoit Cousson <bcousson@baylibre.com>,
        R Sricharan <r.sricharan@ti.com>, "Menon, Nishanth" <nm@ti.com>
Subject: Re: [PATCH v4 4/4] ARM: dts: dra7: add OCP2SCP3 and SATA nodes
Message-ID: <20140514211737.GE27426@atomide.com>
References: <1398274237-24510-1-git-send-email-rogerq@ti.com>
 <1398274575-24818-1-git-send-email-rogerq@ti.com>
 <5369EB78.7080105@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5369EB78.7080105@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140507 01:15]:
> Tony,
> 
> On 04/23/2014 08:36 PM, Roger Quadros wrote:
> > From: Balaji T K <balajitk@ti.com>
> > 
> > Add nodes for OCP2SCP3 bus, SATA controller and SATA PHY.

> > +		sata: sata@4a141100 {
> > +			compatible = "snps,dwc-ahci";
> > +			reg = <0x4a140000 0x1100>, <0x4a141100 0x7>;
> > +			interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
> 
> This will need to be changed like so if the IRQ crossbar changes [1] go in 
> 
> +			interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
> 

Adding this as is into omap-for-v3.16/dt thanks. Sounds like the crossbar
needs more work.

Tony
