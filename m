Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161926Ab3DEIrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:47:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40286 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab3DEIrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:47:12 -0400
Message-ID: <515E8F85.2060700@ti.com>
Date: Fri, 5 Apr 2013 11:47:01 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <linux-omap@vger.kernel.org>
CC: Roger Quadros <rogerq@ti.com>, Paul Walmsley <paul@pwsan.com>,
        <tony@atomide.com>, <rnayak@ti.com>, <b-cousson@ti.com>,
        <santosh.shilimkar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        "Menon, Nishanth" <nm@ti.com>
Subject: Re: [PATCH v2] ARM: OMAP4: clock: Add device tree support for AUXCLKs
References: <1363703220-4777-2-git-send-email-rogerq@ti.com> <1364293408-20677-1-git-send-email-rogerq@ti.com> <515A958B.5080905@ti.com>
In-Reply-To: <515A958B.5080905@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 11:23 AM, Roger Quadros wrote:
> + Paul
> 
> On 03/26/2013 12:23 PM, Roger Quadros wrote:
>> Register a device tree clock provider for the clocks
>> on the OMAP4 SoC. Also provide the binding information.
>>
>> For now we only provide AUXCLKs.

NOTE: this patch depends on
https://patchwork.kernel.org/patch/2312211/

>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  .../devicetree/bindings/clock/omap4-clock.txt      |   33 ++++++++++++++++
>>  arch/arm/boot/dts/omap4.dtsi                       |    5 ++
>>  arch/arm/mach-omap2/cclock44xx_data.c              |   41 ++++++++++++++++++++
>>  3 files changed, 79 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/clock/omap4-clock.txt
>>

cheers,
-roger
