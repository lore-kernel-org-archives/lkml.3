Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3LBQUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:20:01 -0500
Received: from 14.mo4.mail-out.ovh.net ([46.105.40.29]:44537 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752556Ab3LBQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:20:00 -0500
Message-ID: <529CB17D.5090102@overkiz.com>
Date: Mon, 02 Dec 2013 17:12:45 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: add uart aliases to sama5d3 dtsi
References: <1386000604-20829-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1386000604-20829-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12789659992510920812
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 17:10, Nicolas Ferre wrote:

Acked-by Boris BREZILLON <b.brezillon@overkiz.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>   arch/arm/boot/dts/sama5d3_uart.dtsi | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d3_uart.dtsi
> index 49d4d76ca6f4..a9fa75e41652 100644
> --- a/arch/arm/boot/dts/sama5d3_uart.dtsi
> +++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
> @@ -12,6 +12,11 @@
>   #include <dt-bindings/clk/at91.h>
>   
>   / {
> +	aliases {
> +		serial5 = &uart0;
> +		serial6 = &uart1;
> +	};
> +
>   	ahb {
>   		apb {
>   			pinctrl@fffff200 {

