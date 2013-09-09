Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3IIO0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:26:43 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52223 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3IIO0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:26:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCHv4] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <20130909141531.GL9325@radagast>
Date: Mon, 9 Sep 2013 16:26:38 +0200
Cc: <linux-omap@vger.kernel.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        <stable@vger.kernel.org>, George Cherian <george.cherian@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A84D17B9-D194-46CC-8D9C-8CB602F2A332@dominion.thruhere.net>
References: <1378734350-30479-1-git-send-email-koen@dominion.thruhere.net> <20130909141531.GL9325@radagast>
To: <balbi@ti.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 9 sep. 2013, om 16:15 heeft Felipe Balbi <balbi@ti.com> het volgende geschreven:

> Hi,
> 
> On Mon, Sep 09, 2013 at 03:45:50PM +0200, Koen Kooi wrote:
>> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
>> so create a common dtsi both can use.
>> 
>> IMPORTANT: booting the existing am335x-bone.dts will blow up the HDMI transceiver 
>> after a dozen boots with an uSD card inserted because LDO will be at 3.3V instead
>> of 1.8. 
>> 
>> MMC support for AM335x still isn't in, so only the LDO change has been added.
>> 
>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>> Tested-by: Tom Rini <trini@ti.com>
>> Tested-by: Matt Porter <matt.porter@linaro.org>
> 
> not entirelly related to $SUBJECT but having HDMI listed in BBB DTS will
> prevent the use of RF cape, no ?

Complete and utter lack of software from TI for the RF cape is preventing the RF cape from working regardless of HDMI entries.