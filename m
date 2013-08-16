Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3HPKWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:22:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48956 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab3HPKVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:21:36 -0400
Message-ID: <520DFD15.9060900@ti.com>
Date: Fri, 16 Aug 2013 15:51:09 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benoit Cousson <bcousson@baylibre.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <a-kishore@ti.com>, <afzal@ti.com>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH v3] arm: dts: AM43x: Add usb DT nodes for AM4372
References: <1373444082-4169-1-git-send-email-george.cherian@ti.com> <520B9144.5000701@ti.com> <520B958B.1000900@baylibre.com> <520D9A3E.1040903@ti.com> <520DEBF1.6070605@baylibre.com>
In-Reply-To: <520DEBF1.6070605@baylibre.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/2013 2:38 PM, Benoit Cousson wrote:
> That's fine, but that was not my question. Is there any already bindings
> that defined phys and phy-names in the kernel?

No
>
> I couldn't find them in 3.11-rc5.

I will drop the phy reference and send an updated patch adding dwc nodes.

> And anyway the current bindings for dwc3 is not aligned with what you
> are doing here.
> So you have to change the binding before using it in this DTS.
>
> Regards,
> Benoit


-- 
-George

