Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaBKOMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:12:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60347 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaBKOMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:12:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH] can: xilinx CAN controller support.
Date: Tue, 11 Feb 2014 15:12:45 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <6c2bcce0-9897-4d1d-a8b9-47924e40f73c@VA3EHSMHS008.ehs.local> <52FA1910.2060101@pengutronix.de> <52FA2419.70102@monstr.eu>
In-Reply-To: <52FA2419.70102@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402111512.45678.arnd@arndb.de>
X-Provags-ID: V02:K0:xDoUEcs2bNeZNxO/KMkzwPrZtg1N0PdooQkaGQEQinL
 IVZN2y4cjGi9jbEOTRD5l5wFh2bG1ekJcuzWMnBl40uFIk7hsi
 VGNnMbS9EwyxyYMJ/jTjeBAlbTfrLeI4jPT0GQ0Q9buC4SoPHv
 Xsaa4pEEs7cHeAEYdx3ns6mKOT8bJqBn65y5Aozl0xz9h5J6LR
 ATI/40lg9rW3Y7JKuVAEb4kmpD3F4xO6y3O0aYwg/v+6rFwjMW
 eqNT3y+yA0ZMU4WncwjefhuhOaErG0ue+lIizTax6jf2gEg5Oj
 guLWzMaO9Nh/r8mWbIV7Udn4ZVROqXq4BLrOsqpp9QptlDlUid
 AnYEIhc81RkaHquJjhnw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 February 2014, Michal Simek wrote:
> >> The only remaining question is if we should create generic DT binding
> >> for fifo depth. Arnd, Rob: Any opinion about it?
> >> Definitely will be worth to have one generic binding if this is generic feature.
> >> But if this is just specific feature for us then current properties should
> >> be fine.
> >>
> >> In general all these xlnx,XXX properties just reflect all configurable options
> >> which you can setup in design tool which means that provide full hw description
> >> with all variants and they are automatically generated from tools.
> >>
> >> Please let me know what you think.
> > 
> > I like:
> > 
> >     rx-fifo-depth
> >     tx-fifo-depth
> 
> No problem with that. Let Kedar to fix it according this and he will send v2 with this.
> 

Sounds reasonable to me too.

	Arnd
