Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaC1Vx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:53:29 -0400
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:51427
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbaC1Vx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:53:28 -0400
X-Greylist: delayed 954 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2014 17:53:28 EDT
Message-ID: <1396042524.27583.0.camel@linux-builds1>
Subject: Re: [PATCH 1/2] dt/bindings: add binding for ARM Versatile
 character LCD
From: Dinh Nguyen <dinguyen@altera.com>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>
Date: Fri, 28 Mar 2014 16:35:24 -0500
In-Reply-To: <1396041629-28820-1-git-send-email-robherring2@gmail.com>
References: <1396041629-28820-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoNjAwOTAwMSkoNDU4MDAxKSgzNzc0MjQw?=
 =?utf-8?B?MDQpKDI0NDU0MDAyKSg1MTcwNDAwNSkoMTk5MDAyKSgxODkwMDIpKDYyOTY2?=
 =?utf-8?B?MDAyKSg4ODEzNjAwMikoODA5NzYwMDEpKDY1ODE2MDAxKSg0Nzk3NjAwMSko?=
 =?utf-8?B?OTU2NjYwMDMpKDgwMDIyMDAxKSg0Mzk2MDAxKSg0NzczNjAwMSkoOTU0MTYw?=
 =?utf-8?B?MDEpKDMzNzE2MDAxKSg5ODY3NjAwMSkoMzM2NDYwMDEpKDg0Njc2MDAxKSg4?=
 =?utf-8?B?NTMwNjAwMikoOTczMzYwMDEpKDgxMzQyMDAxKSg4NzI4NjAwMSkoODcyNjYw?=
 =?utf-8?B?MDEpKDY5MjI2MDAxKSg5NDMxNjAwMikoNzQzNjYwMDEpKDUwNDY2MDAyKSg5?=
 =?utf-8?B?MzkxNjAwMikoNTAyMjYwMDEpKDQ5ODY2MDAxKSg4NjM2MjAwMSkoOTMxMzYw?=
 =?utf-8?B?MDEpKDkzNTE2MDAyKSgzMTk2NjAwOCkoOTAxNDYwMDEpKDk3MTg2MDAxKSg4?=
 =?utf-8?B?OTk5NjAwMSkoMjM2NzYwMDIpKDc0NzA2MDAxKSg5MjU2NjAwMSkoOTI3MjYw?=
 =?utf-8?B?MDEpKDgzMDcyMDAyKSg0NDk3NjAwNSkoNzQ4NzYwMDEpKDUwOTg2MDAxKSg3?=
 =?utf-8?B?NDUwMjAwMSkoNzQ2NjIwMDEpKDg1ODUyMDAzKSg0NzQ0NjAwMikoNTY3NzYw?=
 =?utf-8?B?MDEpKDc3MDk2MDAxKSg3Njc4NjAwMSkoNzcxNTYwMDEpKDE5NTgwNDA1MDAx?=
 =?utf-8?B?KSg4MzMyMjAwMSkoMTQxMTAwMSkoNTE4NTYwMDEpKDUzODA2MDAxKSg3NjQ4?=
 =?utf-8?B?MjAwMSkoNzc5ODIwMDEpKDgxNTQyMDAxKSg1NjgxNjAwNSkoODc5MzYwMDEp?=
 =?utf-8?B?KDk0OTQ2MDAxKSg5NzczNjAwMSkoNDYxMDIwMDEpKDc2Nzk2MDAxKSgyMDc3?=
 =?utf-8?B?NjAwMykoNTQzMTYwMDIpKDE5NTgwMzk1MDAzKSgyMDA5MDAxKSg0Nzc3NjAw?=
 =?utf-8?B?MykoNjM2OTYwMDIpKDU5NzY2MDAxKSg4MTgxNjAwMSkoNzkxMDIwMDEpKDY4?=
 =?utf-8?B?MDYwMDQpKDgxNjg2MDAxKTtESVI6T1VUO1NGUDoxMTAyO1NDTDoxO1NSVlI6?=
 =?utf-8?B?QkwyRkZPMTFIVUIwMjA7SDpTSi1JVEVYRURHRTAyLmFsdGVyYS5wcml2LmFs?=
 =?utf-8?B?dGVyYS5jb207RlBSOjg4ODNGODMyLkJDQzc0QzI5LjdFREFCMzAuNDg0QUQy?=
 =?utf-8?B?NzEuMjAxREY7TUxWOnNmdjtQVFI6SW5mb0RvbWFpbk5vbmV4aXN0ZW50O0E6?=
 =?utf-8?Q?1;MX:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 01644DCF4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 16:20 -0500, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Add binding doc for Versatile platforms character LCD controller
> interface.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/misc/arm-charlcd.txt | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/arm-charlcd.txt
> 
> diff --git a/Documentation/devicetree/bindings/misc/arm-charlcd.txt b/Documentation/devicetree/bindings/misc/arm-charlcd.txt
> new file mode 100644
> index 0000000..e28e2aa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/arm-charlcd.txt
> @@ -0,0 +1,18 @@
> +ARM Versatile Character LCD
> +-----------------------------------------------------
> +This binding defines the character LCD interface found on ARM Versatile AB
> +and PB reference platforms.
> +
> +Required properties:
> +- compatible : "arm,versatile-clcd"

Should this be "arm,versatile-lcd"?

Dinh
> +- reg : Location and size of character LCD registers
> +
> +Optional properties:
> +- interrupts - single interrupt for character LCD. The character LCD can
> +  operate in polled mode without an interrupt.
> +
> +Example:
> +	lcd@10008000 {
> +		compatible = "arm,versatile-lcd";
> +		reg = <0x10008000 0x1000>;
> +	};


