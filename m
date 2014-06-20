Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829AbaFTPFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:05:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58045 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965663AbaFTPFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:05:16 -0400
Message-ID: <53A44D73.6080200@ti.com>
Date: Fri, 20 Jun 2014 11:04:19 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Herring <robh+dt@kernel.org>
CC: Fabio Estevam <festevam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] dt/documentation: add specification of dma bus information
References: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com> <CAOMZO5Ceg9RpC8Lgt0BwGTuaz-Z2614Die2PrbtT_j4QYjL_sA@mail.gmail.com> <5395BDA7.3060507@ti.com>
In-Reply-To: <5395BDA7.3060507@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2014 09:59 AM, Santosh Shilimkar wrote:
> On Sunday 08 June 2014 10:13 PM, Fabio Estevam wrote:
>> On Thu, Jun 5, 2014 at 12:22 PM, Santosh Shilimkar
>> <santosh.shilimkar@ti.com> wrote:
>>> Recently we introduced the generic device tree infrastructure for couple of DMA
>>> bus parameter, dma-ranges and dma-coherent. Update the documentation so that
>>> its useful for future users.
>>>
>>> The "dma-ranges" property is intended to be used for describing the
>>> configuration of DMA bus RAM addresses and its offset w.r.t CPU addresses.
>>>
>>> The "dma-coherent" property is intended to be used for identifying devices
>>> supported coherent DMA operations.
>>>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Grant Likely <grant.likely@linaro.org>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>>> Cc: Shawn Guo <shawn.guo@freescale.com>
>>> Cc: Kumar Gala <galak@codeaurora.org>
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> ---
>>>  Documentation/devicetree/booting-without-of.txt |   60 +++++++++++++++++++++++
>>>  1 file changed, 60 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
>>> index 1f013bd..f0120c1 100644
>>> --- a/Documentation/devicetree/booting-without-of.txt
>>> +++ b/Documentation/devicetree/booting-without-of.txt
>>> @@ -51,6 +51,8 @@ Table of Contents
>>>
>>>    VIII - Specifying device power management information (sleep property)
>>>
>>> +  VIV - Specifying dma bus information
>>
>> "9" in Roman numeral is "IX"
>>
> Yeah.. Not sure what I was thinking...
> 
Updated patch end of the email with the typo fixed.

Rob,
Can you please pick this up if you are ok with the it.

Regards,
Santosh

>From b72e949a194d766fe029fe6bb5939467f2fbe9b9 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Fri, 20 Jun 2014 11:01:54 -0400
Subject: [PATCH] dt/documentation: add specification of dma bus information

Recently we introduced the generic device tree infrastructure for couple of DMA
bus parameter, dma-ranges and dma-coherent. Update the documentation so that
its useful for future users.

The "dma-ranges" property is intended to be used for describing the
configuration of DMA bus RAM addresses and its offset w.r.t CPU addresses.

The "dma-coherent" property is intended to be used for identifying devices
supported coherent DMA operations.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 Documentation/devicetree/booting-without-of.txt |   60 +++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 1f013bd..0b0928c 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -51,6 +51,8 @@ Table of Contents
 
   VIII - Specifying device power management information (sleep property)
 
+  IX - Specifying dma bus information
+
   Appendix A - Sample SOC node for MPC8540
 
 
@@ -1332,6 +1334,64 @@ reasonably grouped in this manner, then create a virtual sleep controller
 (similar to an interrupt nexus, except that defining a standardized
 sleep-map should wait until its necessity is demonstrated).
 
+IX - Specifying dma bus information
+
+Some devices may have DMA memory range shifted relatively to the beginning of
+RAM, or even placed outside of kernel RAM. For example, the Keystone 2 SoC
+worked in LPAE mode with 4G memory has:
+- RAM range: [0x8 0000 0000, 0x8 FFFF FFFF]
+- DMA range: [  0x8000 0000,   0xFFFF FFFF]
+and DMA range is aliased into first 2G of RAM in HW.
+
+In such cases, DMA addresses translation should be performed between CPU phys
+and DMA addresses. The "dma-ranges" property is intended to be used
+for describing the configuration of such system in DT.
+
+In addition, each DMA master device on the DMA bus may or may not support
+coherent DMA operations. The "dma-coherent" property is intended to be used
+for identifying devices supported coherent DMA operations in DT.
+
+* DMA Bus master
+Optional property:
+- dma-ranges: <prop-encoded-array> encoded as arbitrary number of triplets of
+	(child-bus-address, parent-bus-address, length). Each triplet specified
+	describes a contiguous DMA address range.
+	The dma-ranges property is used to describe the direct memory access (DMA)
+	structure of a memory-mapped bus whose device tree parent can be accessed
+	from DMA operations originating from the bus. It provides a means of
+	defining a mapping or translation between the physical address space of
+	the bus and the physical address space of the parent of the bus.
+	(for more information see ePAPR specification)
+
+* DMA Bus child
+Optional property:
+- dma-ranges: <empty> value. if present - It means that DMA addresses
+	translation has to be enabled for this device.
+- dma-coherent: Present if dma operations are coherent
+
+Example:
+soc {
+		compatible = "ti,keystone","simple-bus";
+		ranges = <0x0 0x0 0x0 0xc0000000>;
+		dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;
+
+		[...]
+
+		usb: usb@2680000 {
+			compatible = "ti,keystone-dwc3";
+
+			[...]
+
+			dma-coherent;
+			dma-ranges;
+
+			dwc3@2690000 {
+				compatible = "synopsys,dwc3";
+				[...]
+			};
+		};
+};
+
 Appendix A - Sample SOC node for MPC8540
 ========================================
 
-- 
1.7.9.5

