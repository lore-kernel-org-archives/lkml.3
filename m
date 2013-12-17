Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3LQX5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:57:32 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:48384
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448Ab3LQX52 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:57:28 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z579eh551biz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Tue, 17 Dec 2013 15:57:16 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <arm@kernel.org>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>, <olof@lixom.net>,
        <peter.crosthwaite@xilinx.com>, <linux@roeck-us.net>
Subject: Re: [PATCH v5 2/2] ARM: mach-moxart: add MOXA ART SoC device tree
 files
References: <1387294714-12872-1-git-send-email-jonas.jensen@gmail.com>
 <1387294714-12872-3-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1387294714-12872-3-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <532508e4-1b5f-46ba-9519-7a3e019e251b@CH1EHSMHS014.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

On Tue, Dec 17, 2013 at 04:38:34PM +0100, Jonas Jensen wrote:
> Add a generic (dtsi) include file for MOXA ART SoCs.
> 
> Also add a file for UC-7112-LX.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/moxart.txt |  12 ++
>  arch/arm/boot/dts/Makefile                       |   1 +
>  arch/arm/boot/dts/moxart-uc7112lx.dts            |  93 +++++++++++++
>  arch/arm/boot/dts/moxart.dtsi                    | 167 +++++++++++++++++++++++
>  4 files changed, 273 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/moxart.txt
>  create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
>  create mode 100644 arch/arm/boot/dts/moxart.dtsi
> 
> diff --git a/Documentation/devicetree/bindings/arm/moxart.txt b/Documentation/devicetree/bindings/arm/moxart.txt
> new file mode 100644
> index 0000000..11087ed
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/moxart.txt
> @@ -0,0 +1,12 @@
> +MOXA ART device tree bindings
> +
> +Boards with the MOXA ART SoC shall have the following properties:
> +
> +Required root node property:
> +
> +compatible = "moxa,moxart";
> +
> +Boards:
> +
> +- UC-7112-LX: embedded computer
> +  compatible = "moxa,moxart-uc-7112-lx", "moxa,moxart"
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index c55a22d..ae3d7db 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -319,6 +319,7 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
>  dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb \
>  	zynq-zc706.dtb \
>  	zynq-zed.dtb
> +dtb-$(CONFIG_ARCH_MOXART) += moxart-uc7112lx.dtb
I think these targets are sorted alphabetically. You should insert the
MOXART target at the appropriate location a little further up.

	Sören


