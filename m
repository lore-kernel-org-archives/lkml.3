Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3HVHrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:47:41 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:56165 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab3HVHrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:47:39 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.831
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] of: add vendor prefix for Microchip Technology Inc
Date: Thu, 22 Aug 2013 09:47:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: rob.herring@calxeda.com, Pawel Moll <Pawel.Moll@arm.com>,
        mark.rutland@arm.com, ian.campbell@citrix.com, rob@landley.net,
        Grant Likely <grant.likely@linaro.org>, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201308211719.57748.poeschel@lemonage.de> <5214FBA8.5000603@wwwdotorg.org>
In-Reply-To: <5214FBA8.5000603@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308220947.29715.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 August 2013 at 19:40:56, Stephen Warren wrote:
> On 08/21/2013 09:19 AM, Lars Poeschel wrote:
> > Trivial patch to add Microchip Technology Inc. to the list
> > of devicetree vendor prefixes, as it is already used in
> > Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> 
> Oh dear. Perhaps it can be legacy-ified...
> 
> > diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt
> > 
> > +mcp	Microchip Technology Inc.
> 
> If I saw "mcp," in a *.dts file, I wouldn't immediately think
> "Microchip".
> 
> Their stock ticker appears to be MCHP, so I'd suggest either "mchp" or
> "microchip" instead; that latter being my personal preference.

Any other opinions?
If there are other voices who don't like it, we can change it. There is no 
in-tree dts file using this yet.
How can a renaming be done? Would that involve changing the drivers (and 
module) name too? Or do we have the difference between "mcp" in the drivers 
name and "microchip" for device tree properties? In the latter case, I'd 
vote against it - if anyone cares. ;-)

Lars
