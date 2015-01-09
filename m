Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbbAIPMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:12:47 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:61172 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbbAIPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:12:46 -0500
Message-ID: <54AFEFEC.5000300@cogentembedded.com>
Date: Fri, 09 Jan 2015 18:12:44 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 4/8] irqchip: devicetree: document Conexant Digicolor
 irq binding
References: <cover.1420744368.git.baruch@tkos.co.il> <3bdf8fa0bf971b4881024e72312c3c9d29298e79.1420744369.git.baruch@tkos.co.il>
In-Reply-To: <3bdf8fa0bf971b4881024e72312c3c9d29298e79.1420744369.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/8/2015 10:40 PM, Baruch Siach wrote:

> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>   .../bindings/interrupt-controller/digicolor-ic.txt   | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt

> diff --git a/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
> new file mode 100644
> index 000000000000..fdf9a4c59bf3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
> @@ -0,0 +1,20 @@
> +Conexant Digicolor Interrupt Controller
> +
> +Required properties:
> +
> +- compatible : should be "cnxt,cx92755-ic"
> +- reg : Specifies base physical address and size of the MISC area, that is
> +  where the interrupt controller registers are located
> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +  interrupt source. The value shall be 1.
> +
> +Example:
> +
> +	intc: intc@f0000000 {

    The node name should be "interrupt-controller@f0000000", according to the 
ePAPR standard, section 2.2.2.

[...]

WBR, Sergei

