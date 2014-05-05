Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaEEXSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:18:06 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:55043
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771AbaEEXSD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:18:03 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(z579ehz98dIc89bh936eI1432Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h27e2h906i2673i)
Date: Mon, 5 May 2014 16:16:52 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: <tthayer@altera.com>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [PATCHv3 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
 <1399330337-16748-2-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1399330337-16748-2-git-send-email-tthayer@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ba35254f-4ba5-4b2c-8056-cde5c693b0ff@CH1EHSMHS009.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thor,

On Mon, 2014-05-05 at 05:52PM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> Addition of the Altera SDRAM controller bindings and device
> tree changes to the Altera SoC project. The "syscon" parameter
> is included here because the SDRAM EDAC bits are shared with the SDRAM
> configuration bits.
> ---
> v2: Changes to SoC SDRAM EDAC code.
> 
> V3: Implement code suggestions for SDRAM EDAC code.
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> ---
>  .../bindings/arm/altera/socfpga-sdram.txt          |   14 ++++++++++++++
>  arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
>  2 files changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> new file mode 100644
> index 0000000..525cb76
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> @@ -0,0 +1,14 @@
> +Altera SOCFPGA SDRAM Controller
> +
> +Required properties:
> +- compatible : "altr,sdr-ctl", "syscon";
> +                Note that syscon is invoked for this device to support the FPGA
> +		bridge driver, EDAC driver and other devices that share the
> +		registers.

This sounds like implementation specifics, which shouldn't be part of
the bindings.

	Sören


