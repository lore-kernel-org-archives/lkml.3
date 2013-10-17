Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722Ab3JQUId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:08:33 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:55978 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762574Ab3JQUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:08:31 -0400
Message-ID: <526043BA.5040100@baylibre.com>
Date: Thu, 17 Oct 2013 22:08:26 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: tony@atomide.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rogerq@ti.com, George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH v2 2/2] ARM: dts: omap5: Add dr_mode for dwc3
References: <52580F34.8030809@ti.com> <1381816199-7966-1-git-send-email-kishon@ti.com> <525E91D4.30509@ti.com>
In-Reply-To: <525E91D4.30509@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 16/10/2013 15:17, Kishon Vijay Abraham I wrote:
> Benoit,
>
> On Tuesday 15 October 2013 11:19 AM, Kishon Vijay Abraham I wrote:
>> From: George Cherian <george.cherian@ti.com>
>>
>> Added dr_mode property in dwc3 and set its default mode to device.
>> Currently dwc3 driver doesn't have support for OTG mode. So explicitly
>> setting to peripheral even dwc3 is a OTG controller since OMAP5 has
>> already got an EHCI host.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> Can you take this patch for 3.13?

I've just applied it.

Thanks,
Benoit


-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
