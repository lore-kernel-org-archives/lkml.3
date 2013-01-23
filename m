Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3AWO1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:27:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51279 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab3AWO1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:27:09 -0500
Message-ID: <50FFF31D.2070908@ti.com>
Date: Wed, 23 Jan 2013 19:56:37 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: Koen Kooi <koen@dominion.thruhere.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "linux-omap@vger.kernel.org List" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1 0/6] USB: Add support for multiple PHYs of same type
References: <1358848694-20145-1-git-send-email-kishon@ti.com> <2D906ABA-71F2-4843-9DBE-F82527A1240A@dominion.thruhere.net> <50FEB3FD.3050001@ti.com> <50FEBB61.9000707@ti.com> <B9531499-0746-44DA-BDBB-999D4CA31E63@dominion.thruhere.net> <C8443D0743D26F4388EA172BF4E2A7A93EA922F5@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA922F5@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Afzal,

On Wednesday 23 January 2013 07:28 PM, Mohammed, Afzal wrote:
> Hi Koen,
>
> On Tue, Jan 22, 2013 at 22:32:56, Koen Kooi wrote:
>
>> Actually it uses nop-phy as a phy, which is missing from arch/arm/boot/dts/am33xx.dtsi, so mainline is already broken. But adding the nop-phy to the DT is easy enough to patch in locally.
>
> USB first instance of am335x works in mainline as of now.

Can you check if this series indeed breaks am335x?

Thanks for your help.

Regards
Kishon
