Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab3D2Mcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:32:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44368 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab3D2Mca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:32:30 -0400
Message-ID: <517E6852.5010001@ti.com>
Date: Mon, 29 Apr 2013 15:32:18 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <b-cousson@ti.com>, <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>, <nm@ti.com>, <paul@pwsan.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3 0/4] ARM: dts: Add USB host support for Panda and Beagle-xm
References: <1366365457-28972-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1366365457-28972-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 12:57 PM, Roger Quadros wrote:
> Hi Benoit/Tony
> 
> I've consolidated all the USB host device tree patches for Panda and Beagles
> to one place and addressed Tony's comments.
> 
> NOTE: patch 1 depends on OMAP clock binding introduced in
> https://lkml.org/lkml/2013/4/12/407

Tony, Benoit,

Just FYI, the patch [1] that is needed will probably not get in
until 3.10 rc1. However, this series need not wait till that happens.

[1] https://lkml.org/lkml/2013/4/12/407

cheers,
-roger

> 
> v3:
> - updated mux mode to use pulldowns on panda as non-DT boot uses pulldowns.
> - fixed usb pin naming for panda, beagle and beagle-xm
> 
> The following changes since commit 1fac4fffa719a98ec1047eaece236244333c9afe:
> 
>   ARM: dts: Add OMAP3430 SDP NOR flash memory binding (2013-04-09 00:21:35 +0200)
> 
> are available in the git repository at:
>   git://github.com/rogerq/linux.git usbhost-omap-dts
> 
> Roger Quadros (4):
>       ARM: dts: omap4-panda: Add USB Host support
>       ARM: dts: omap3-beagle: Make USB host pin naming consistent
>       ARM: dts: omap3-beagle-xm: Add USB Host support
>       ARM: dts: omap3-beagle-xm: Add USB host supprot for Rev. Ax/Bx
> 
>  arch/arm/boot/dts/omap3-beagle-xm-ab.dts  |   19 ++++++++
>  arch/arm/boot/dts/omap3-beagle-xm.dts     |   65 ++++++++++++++++++++++++++++-
>  arch/arm/boot/dts/omap3-beagle.dts        |   25 ++++++-----
>  arch/arm/boot/dts/omap4-panda-common.dtsi |   58 +++++++++++++++++++++++++
>  arch/arm/boot/dts/omap4.dtsi              |    5 ++
>  5 files changed, 158 insertions(+), 14 deletions(-)
>  create mode 100644 arch/arm/boot/dts/omap3-beagle-xm-ab.dts
> 

