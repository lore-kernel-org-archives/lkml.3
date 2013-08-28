Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3H1RgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:36:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49163 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab3H1RgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:36:10 -0400
Message-ID: <521E34F4.3060402@ti.com>
Date: Wed, 28 Aug 2013 23:05:48 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob@landley.net>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>,
        <davidb@codeaurora.org>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <popcornmix@gmail.com>
Subject: Re: [PATCH v2 0/3] Add Generic USB VBUS/ID detection via GPIO using
 extcon
References: <1377698352-27689-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1377698352-27689-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/2013 7:29 PM, George Cherian wrote:
> Hi,
>
> These patches add generic support for USB VBUS/ID pin detection using extcon framework.
> The USB ID pin on DRA7xx is connected via the gpio expander pcf8575.
> The interrupt line of the same is connected to the gpio 11 of bank 6.
> The following driver relies on  the  gpio interrupt to notify the actual
> ID pin values by which the dwc3 driver determines the HOST/Peripheral roles.
Please ignore this patch set I just noticed that patch #1 is malformed.
Sending v3 in a while.

Regards,
-George
