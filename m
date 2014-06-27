Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaF0MXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:23:48 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:36537 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaF0MXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:23:46 -0400
Message-ID: <53AD625B.1080002@cogentembedded.com>
Date: Fri, 27 Jun 2014 16:23:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        robh+dt@kernel.org, Peter.Chen@freescale.com,
        gregkh@linuxfoundation.org, galak@codeaurora.org,
        rdunlap@infradead.org, michal.simek@xilinx.com
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [PATCH v2 1/2] usb: chipidea: zynq: Add device tree binding information
References: <6233f866-678d-4a90-a307-debcb848ae76@BN1AFFO11FD023.protection.gbl>
In-Reply-To: <6233f866-678d-4a90-a307-debcb848ae76@BN1AFFO11FD023.protection.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/27/2014 03:23 PM, Punnaiah Choudary Kalluri wrote:

> Document device tree binding information as required by
> the ZYNQ USB controller.

> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
[...]

> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt
> new file mode 100644
> index 0000000..54bb3b4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt
> @@ -0,0 +1,23 @@
> +Xilinx Zynq usb controller based on synopsys usb IP(v2.20a)

    s/usb/USB/.

> +
> +Required properties:
> +- compatible:   should contain "xlnx,zynq-usb-2.20a"
> +- clocks:       clock provider specifier
> +- reg:          offset and length of the register set in the memory map
> +- interrupt-parent: the phandle for the interrupt controller that services
> +                    interrupts for this device.

    This property has never been required -- it can be inherited from the 
upper level node.

WBR, Sergei


