Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaHEMBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:01:06 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52694 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaHEMBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:01:03 -0400
Message-ID: <53E0C70E.2010603@gmail.com>
Date: Tue, 05 Aug 2014 17:29:10 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Srikanth Thokala <sthokal@xilinx.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org, levex@linux.com,
        jassisinghbrar@gmail.com
CC: linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        anirudh@xilinx.com, svemula@xilinx.com
Subject: Re: [PATCH v2 1/2] dma: Add Xilinx Central DMA DT Binding Documentation
References: <1407238791-3370-1-git-send-email-sthokal@xilinx.com>
In-Reply-To: <1407238791-3370-1-git-send-email-sthokal@xilinx.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 05:09 PM, Srikanth Thokala wrote:
> Device-tree binding documentation of Xilinx Central DMA Engine
>
> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
> ---
> Changes in v2:
> - Change property 'xlnx,data-width' to 'xlnx,datawidth' in the description
>    to match the implementation.
>
> ---
>   .../devicetree/bindings/dma/xilinx/xilinx_cdma.txt |   54 ++++++++++++++++++++
>   1 file changed, 54 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_cdma.txt
>
> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_cdma.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_cdma.txt
> new file mode 100644
> index 0000000..b04f76b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_cdma.txt
> @@ -0,0 +1,54 @@
> +Xilinx AXI CDMA engine, it does transfers between memory-mapped source
> +address and a memory-mapped destination address.
> +
> +Required properties:
> +- compatible: Should be "xlnx,axi-cdma-1.00.a"
> +- #dma-cells: Should be <1>, see "dmas" property below
> +- reg: Should contain cdma registers location and length.
> +- dma-channel child node: Should have only one channel
> +
> +

proper alignment for all the properties...
Required properties:
- compatible	: Should be "xlnx,axi-cdma-1.00.a"
- #dma-cells	: Should be <1>, see "dmas" property below
- reg		: Should contain cdma registers location and length.
.....



-- 
Regards,
Varka Bhadram.

