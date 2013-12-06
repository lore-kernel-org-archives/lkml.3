Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3LFJPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:15:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48694 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab3LFJPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:15:21 -0500
Message-ID: <52A1957C.5090801@ti.com>
Date: Fri, 6 Dec 2013 11:14:36 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: <bcousson@baylibre.com>, <paul@pwsan.com>, <balbi@ti.com>, <sr@denx.de>,
        <David.Laight@ACULAB.COM>, <michael@amarulasolutions.com>,
        <bigeasy@linutronix.de>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ARM: OMAP2+: USB Host bug fixes for 3.13 rc
References: <1386080748-17005-1-git-send-email-rogerq@ti.com> <529EFD42.9070507@ti.com> <20131205184832.GG26766@atomide.com>
In-Reply-To: <20131205184832.GG26766@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

On 12/05/2013 08:48 PM, Tony Lindgren wrote:
> * Tomi Valkeinen <tomi.valkeinen@ti.com> [131204 02:01]:
>> On 2013-12-03 16:25, Roger Quadros wrote:
>>> Hi,
>>>
>>> This is a follow up solution to the original series in [1]
>>>
>>> The first patch fixes the OMAP4 Panda USB detection problems on 3.13-rc1
>>> with u-boot v2013.10.
>>>
>>> The remaining 2 patches are required if SOFTRESET needs to be done for the
>>> USB Host module on OMAP3 platforms.
>>>
>>> Patch 2 fixes the hwmod RESET logic to prevent multiple SOFTRESETs
>>> being issued to the modules. This multiple SOFTRESET was causing problems
>>> with OMAP3 USB Host module. On Beagleboard C4 this is seen as failure to
>>> mount NFS root over external USB to Ethernet device.
>>>
>>> This might be the reason why HWMOD_INIT_NO_RESET was used for the OMAP
>>> USB host module in OMAP3 hwmod data and just carried forward in OMAP4
>>> and OMAP5 hwmod data as well.
>>>
>>> cheers,
>>> -roger
>>
>> Tested on Panda and Beagle xM. Works fine for me.
> 
> Looks like we should merge these as regression fixes during the -rc
> cycle. Paul should take a look at these first though.

At least the first one must be taken ASAP. The other two would be nice to have though.

cheers,
-roger
