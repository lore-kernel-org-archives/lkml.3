Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3JOGx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:53:29 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:42498 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3JOGx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:53:26 -0400
Message-ID: <525CE662.3000704@baylibre.com>
Date: Tue, 15 Oct 2013 08:53:22 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, pavel@ucw.cz, aaro.koskinen@iki.fi, marek@goldelico.com,
        tony@atomide.com, kishon@ti.com, bigeasy@linutronix.de,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: dts: omap3:  Adapt USB OTG to generic PHY framework
References: <1381152493-28055-1-git-send-email-rogerq@ti.com> <1381152493-28055-2-git-send-email-rogerq@ti.com> <20131010153427.GI28375@radagast> <525BB74B.2040702@ti.com>
In-Reply-To: <525BB74B.2040702@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On 14/10/2013 11:20, Roger Quadros wrote:
> Hi Benoit,
>
> On 10/10/2013 06:34 PM, Felipe Balbi wrote:
>> On Mon, Oct 07, 2013 at 04:28:13PM +0300, Roger Quadros wrote:
>>> The generic PHY framewrok expects different properties than the
>>> old USB PHY framework. Supply those properties.
>>>
>>> Fixes USB OTG port on GAT04 and N900 after the Generic PHY framework was
>>> merged in greg/usb-next. [1]
>>>
>>> [1] - https://lkml.org/lkml/2013/9/27/581
>>>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>>
>
> Could you please pick this one for 3.13? Thanks.
>
> I don't see it in your 3.13 take 2 pull request.

It was not in it. I've just applied it.

Thanks
Benoit

-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
