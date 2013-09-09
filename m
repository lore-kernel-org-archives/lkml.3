Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3IINUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:20:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35803 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab3IINT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:19:58 -0400
Message-ID: <522DCAC6.8080705@ti.com>
Date: Mon, 9 Sep 2013 09:19:02 -0400
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: <linux-omap@vger.kernel.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <olof@lixom.net>
Subject: Re: [PATCHv3] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
References: <1378638746-10627-1-git-send-email-koen@dominion.thruhere.net>
In-Reply-To: <1378638746-10627-1-git-send-email-koen@dominion.thruhere.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2013 07:12 AM, Koen Kooi wrote:
> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
> so create a common dtsi both can use.
> 
> IMPORTANT: booting the existing am335x-bone.dts will blow up the HDMI transceiver 
> after a dozen boots with an uSD card inserted because LDO will be at 3.3V instead
> of 1.8. 
> 
> MMC support for AM335x still isn't in, so only the LDO change has been added.
> 
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>

Grabbed my beaglebone white and black and tested them both on top of
e5c832d (top of Linus' tree atm), came up with a ramdisk.

Tested-by: Tom Rini <trini@ti.com>

-- 
Tom
