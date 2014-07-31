Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaGaVKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:10:07 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:37335 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaGaVKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:10:04 -0400
Message-ID: <53DAB0A6.9030700@gmail.com>
Date: Thu, 31 Jul 2014 23:09:58 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/4] ARM: dts: Add exynos5250-spring device tree
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-5-git-send-email-afaerber@suse.de> <53DA936E.9060004@gmail.com> <53DAA8E6.3010400@suse.de>
In-Reply-To: <53DAA8E6.3010400@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 31.07.2014 22:36, Andreas Färber wrote:
> Am 31.07.2014 21:05, schrieb Tomasz Figa:
>>> +	};
>>> +
>>> +	fixed-rate-clocks {
>>> +		xxti {
>>> +			compatible = "samsung,clock-xxti";
>>> +			clock-frequency = <24000000>;
>>> +		};
>>> +	};
>>
>> This is also referencing a node from higher level, so it should be done
>> using a reference.
> 
> Actually this one isn't! Neither fixed-rate-clocks nor xxti exists in
> the .dtsi.

You've got me here. :)

In new dts I actually suggest to specify those on SoC level, since they
are generic SoC inputs and just override their frequencies on board
level, but apparently Exynos5250 doesn't follow this fashion. So this is
fine as is, sorry for noise.

Best regards,
Tomasz
