Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaDCSpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:45:23 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:38185 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaDCSpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <46a3a23e-786e-4acf-aa42-c3808b1a46d3@CH1EHSMHS028.ehs.local>
References: <ee057d8c-50d9-4d4b-ac86-d7c5fc44b1b0@TX2EHSMHS034.ehs.local>
	<46a3a23e-786e-4acf-aa42-c3808b1a46d3@CH1EHSMHS028.ehs.local>
Date: Fri, 4 Apr 2014 00:15:17 +0530
Message-ID: <CAFcVECLoB8BR0PVfV=1EVQub8weOOYustg-1DqOevaihCT3JqQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] devicetree: Add devicetree bindings documentation for
 Zynq Quad SPI
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        broonie@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Punnaiah Choudary <kpc528@gmail.com>,
        kalluripunnaiahchoudary@gmail.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren

On Thu, Apr 3, 2014 at 11:20 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> Hi Punnaiah,
>
> On Thu, 2014-04-03 at 10:33PM +0530, Punnaiah Choudary Kalluri wrote:
>> Add bindings documentation for Zynq Quad SPI driver.
>>
>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>> ---
>>  .../devicetree/bindings/spi/spi-zynq-qspi.txt      |   26 ++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
>>
>> diff --git a/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt b/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
>> new file mode 100644
>> index 0000000..88e00f8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
>> @@ -0,0 +1,26 @@
>> +Xilinx Zynq QSPI controller Device Tree Bindings
>> +-------------------------------------------------
>> +
>> +Required properties:
>> +- compatible         : Should be "xlnx,zynq-qspi-1.0".
>> +- reg                        : Physical base address and size of QSPI registers map.
>> +- interrupts         : Property with a value describing the interrupt
>> +                       number.
>> +- interrupt-parent   : Must be core interrupt controller
>> +- clock-names                : List of input clock names - "ref_clk", "aper_clk"
>> +                       (See clock bindings for details).
>> +- clocks             : Clock phandles (see clock bindings for details).
>> +
>> +Optional properties:
>> +- num-cs             : Number of chip selects used.
>> +
>> +Example:
>> +     qspi@e000d000 {
>> +             compatible = "xlnx,zynq-qspi-1.0";
>> +             clock-names = "ref_clk", "aper_clk";
>
> These seem to be the SOC names of the clocks. Doesn't have the IP its
> own naming for these clock inputs?
>

The IP design spec uses the name ref_clk.
There is no particular clock name used for for APB clock.
So I think aper_clk is a valid name to use.

Regards,
Harini
