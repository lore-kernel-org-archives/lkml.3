Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3LBNPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:15:06 -0500
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:33122 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751515Ab3LBNPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:15:01 -0500
Message-ID: <529C835B.7050908@overkiz.com>
Date: Mon, 02 Dec 2013 13:55:55 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org, jiri.prchal@aksignal.cz
Subject: Re: [PATCH v2] ARM: at91: add usart3 alias to dtsi
References: <1385979186-29447-1-git-send-email-nicolas.ferre@atmel.com> <1385988793-1787-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1385988793-1787-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 9465159041998944364
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

On 02/12/2013 13:53, Nicolas Ferre wrote:
> Alias was missing for SoC of the at91sam9x5 familly that embed USART3.
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
>
> Reported-by: Jiri Prchal <jiri.prchal@aksignal.cz>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Boris Brezillon <b.brezillon@overkiz.com>
> ---
>   arch/arm/boot/dts/at91sam9x5_usart3.dtsi | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
> index 2347e9563cef..6801106fa1f8 100644
> --- a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
> @@ -11,6 +11,10 @@
>   #include <dt-bindings/interrupt-controller/irq.h>
>   
>   / {
> +	aliases {
> +		serial4 = &usart3;
> +	};
> +
>   	ahb {
>   		apb {
>   			pinctrl@fffff400 {

