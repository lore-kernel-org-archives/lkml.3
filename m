Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3HMNZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:25:47 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35339 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753Ab3HMNZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:25:45 -0400
Message-ID: <520A33D6.5070700@baylibre.com>
Date: Tue, 13 Aug 2013 15:25:42 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: Mark Rutland <mark.rutland@arm.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: am33xx: Correct gpio #interrupt-cells property
References: <1375873592-26881-1-git-send-email-larsi@wh2.tu-dresden.de> <20130807145309.GG28558@e106331-lin.cambridge.arm.com> <201308071711.00449.poeschel@lemonage.de>
In-Reply-To: <201308071711.00449.poeschel@lemonage.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lars,

On 07/08/2013 17:11, Lars Poeschel wrote:
> On Wednesday 07 August 2013 at 16:53:09, Mark Rutland wrote:
>> On Wed, Aug 07, 2013 at 12:06:32PM +0100, Lars Poeschel wrote:
>>> From: Lars Poeschel <poeschel@lemonage.de>
>>>
>>> Following commit ff5c9059 and therefore other omap platforms using
>>> the gpio-omap driver correct the #interrupt-cells property on am33xx
>>> too. The omap gpio binding documentaion also states that
>>> the #interrupt-cells property should be 2.
>>
>> I take it there are no device nodes for which any of these nodes are an
>> interrupt parent (which would need to be updated)?
>
> As far as I know: No.
>
> Lars
>
>> If so:
>>
>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>>
>> Thanks,
>> Mark.
>>
>>> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Thank, applied with Mark and Javier A-By / R-By.

Thanks,
Benoit


