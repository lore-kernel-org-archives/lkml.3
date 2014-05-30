Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbaE3NQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:16:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59474 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbaE3NQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:16:54 -0400
Message-ID: <538884C4.5070304@ti.com>
Date: Fri, 30 May 2014 08:16:52 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>, Tony Lindgren <tony@atomide.com>
CC: Sourav Poddar <sourav.poddar@ti.com>, <bcousson@baylibre.com>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Nayak, Rajendra" <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [Resend/PATCH] arm: dts: dra7: Add qspi device.
References: <1399374445-16456-1-git-send-email-sourav.poddar@ti.com> <20140506165254.GN18474@atomide.com> <53886CB7.4070104@ti.com>
In-Reply-To: <53886CB7.4070104@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 06:34 AM, Sricharan R wrote:
> Hi,
> 
> On Tuesday 06 May 2014 10:22 PM, Tony Lindgren wrote:
>> * Sourav Poddar <sourav.poddar@ti.com> [140506 04:08]:
>>> These add device tree entry for qspi controller driver on dra7-evm.
>> Thanks applying into omap-for-v3.16/dt.
> There is a problem with this. The qspi node defines crossbar number
>  as its interrupt number. Since the crossbar dts patches are not yet
>  there, this causes a warning during boot.  So interrupts = < >
>  property should be removed from DT and added later by crossbar series.
> 

https://github.com/nmenon/kernel-test-logs/blob/next-20140530/omap2plus_defconfig/dra7.txt#L151
as an indication of the warning.

Tony,
Would you prefer a patch on top of omap-for-v3.16/dt-v2 branch?

-- 
Regards,
Nishanth Menon
