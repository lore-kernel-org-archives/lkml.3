Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaAHLtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:49:33 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50657 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbaAHLtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:49:32 -0500
Message-ID: <52CD3B1D.5080203@ti.com>
Date: Wed, 8 Jan 2014 17:18:45 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Sebastian Reichel <sre@debian.org>, <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, <tony@atomide.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, "Kristo, Tero" <t-kristo@ti.com>,
        <bcousson@baylibre.com>, <linux-omap@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <3761842.HRY1CDBF4z@wuerfel> <52CD324D.3020701@ti.com> <201401081235.40927.arnd@arndb.de>
In-Reply-To: <201401081235.40927.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 05:05 PM, Arnd Bergmann wrote:
> On Wednesday 08 January 2014, Roger Quadros wrote:
>> OK. I'll update the binding information to reflect all the clocks.
>>
>> But what about clk_get() vs of_clk_get_by_name() ?
> 
> I think the convention these days is to just use clk_get(), which calls
> of_clk_get_by_name() internally. Not sure if that's what you are asking.
>

OK fine. I'll continue to use clk_get() then.

cheers,
-roger
