Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbaKTMsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:48:35 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20284 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaKTMsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:48:32 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-f4-546de31defd1
Message-id: <546DE31B.20602@samsung.com>
Date: Thu, 20 Nov 2014 13:48:27 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
References: <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com> <20141118084603.GC4059@amd>
 <546B19C8.2090008@samsung.com> <20141118113256.GA10022@amd>
 <546B40FA.2070409@samsung.com> <20141118132159.GA21089@amd>
 <546B6D86.8090701@samsung.com> <20141118165148.GA11711@amd>
 <546C66A5.6060201@samsung.com> <20141120121202.GA27527@amd>
In-reply-to: <20141120121202.GA27527@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xK7qyj3NDDNpfiVqseeFgcWf+X1aL
	+UfOsVo8/qpn0f9mIavFuVcrGS2ebn7MZLHp8TVWi8u75rBZbH2zjtGiZ8NWVovZS/pZLJZe
	v8hkMfH0byaLu6eOsllMmL6WxaJ17xF2izP7V7JZvL7ziMli+acIi/1XvBxEPY6ef8XqsWbe
	GkaPb18nsXi8v9HK7nG5r5fJ41fbXGaPnbPusnusXP6FzePw14UsHptWdbJ5bF5S77H30A92
	jxWrv7N7fN4kF8AXxWWTkpqTWZZapG+XwJWx/+MkxoJGnorZvxexNDDO4exi5OSQEDCReH7n
	BjuELSZx4d56ti5GLg4hgaWMEms3/WKHcD4yStw9+pQJpIpXQEPi5bMmNhCbRUBVYs7HaSwg
	NpuAocTPF6/BakQFIiT+nN7HClEvKPFj8j2wGhEBeYmtfSuYQYYyC2xikZi+fwlYg7CAu8TM
	G5egtn1mkvizbT9YB6eApsSbjW/AipgFrCVWTtrGCGHLS2xe85Z5AqPALCRLZiEpm4WkbAEj
	8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkDj+soNx8TGrQ4wCHIxKPLwHHHNDhFgTy4or
	cw8xSnAwK4nwauwECvGmJFZWpRblxxeV5qQWH2Jk4uCUamDU4e+W7J6Z8vGF7cKSQ3sWTrHT
	6zFhWZag+iPlr9R6LoN1Ff8SN/4667feLawp/6vFEY0QjSUrTjbOFMsovZdvx/S2xOTjnNVW
	Vd+ect2Z9yQmx3SbnuhFu/NWzzYurvu1YXvPS7agd74SD/UCrP+Yvw0/Hlm53o3pwl+G8Bma
	fd/d7itGHORQYinOSDTUYi4qTgQAmNkaOcECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 11/20/2014 01:12 PM, Pavel Machek wrote:
> Hi!
>
>> I would also swap the segments of a property name to follow the convention
>> as in case of "regulator-max-microamp".
>>
>> Updated version:
>>
>> ==========================================================
>>
>> Optional properties for child nodes:
>> - max-microamp : maximum intensity in microamperes of the LED
>> 		 (torch LED for flash devices)
>> - flash-max-microamp : maximum intensity in microamperes of the
>> 		       flash LED; it is mandatory if the led should
>> 		       support the flash mode
>> - flash-timeout-microsec : timeout in microseconds after which the flash
>> 		           led is turned off
>
> Works for me. Do you want to submit a patch or should I do it?

You can submit a patch for leds/common.txt and a separate patch for the
adp1653 with a reference to the leds/common.txt for the child nodes.

>
>> - indicator-pattern : identifier of the blinking pattern for the
>> 		      indicator led
>>
>
> This would need a bit more documentation, no?

- indicator-pattern : identifier of the blinking pattern for the
  		      indicator led; valid identifiers should be
		      defined in the documentation of the parent
		      node.

I wouldn't go for pre-defined identifiers as the pattern
can be a combination of various settings like ramp-up, ramp-down,
pulse time etc. Drivers should expose only few combinations of
these settings in my opinion, like e.g. leds-lm355x.c does.

Regards,
Jacek

