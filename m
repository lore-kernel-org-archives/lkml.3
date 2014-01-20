Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaATJPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:15:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38052 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaATJPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:15:44 -0500
Message-ID: <52DCE90F.8040908@ti.com>
Date: Mon, 20 Jan 2014 11:14:55 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <sre@debian.org>, <mark.rutland@arm.com>,
        <m.paolino@virtualopensystems.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v5 3/9] mfd: omap-usb-host: Update DT clock binding information
References: <1389269303-30465-1-git-send-email-rogerq@ti.com> <1389269303-30465-4-git-send-email-rogerq@ti.com> <20140110101107.GF28141@lee--X1>
In-Reply-To: <20140110101107.GF28141@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 12:11 PM, Lee Jones wrote:
> On Thu, 09 Jan 2014, Roger Quadros wrote:
> 
>> The omap-usb-host driver expects certained named clocks.
>> Add this information to the DT binding document.
>>
>> Use clock names as per function for reference clocks.
>>
>> CC: Lee Jones <lee.jones@linaro.org>
>> CC: Samuel Ortiz <sameo@linux.intel.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  .../devicetree/bindings/mfd/omap-usb-host.txt      | 23 ++++++++++++++++++++++
>>  drivers/mfd/omap-usb-host.c                        |  6 +++---
>>  2 files changed, 26 insertions(+), 3 deletions(-)
> 
> Please don't mix up binding changes with code ones.
> 
> Separate patch please.
> 
OK.

cheers,
-roger
