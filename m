Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaDYRzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:55:18 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:56350 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaDYRzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:55:14 -0400
Message-ID: <535AA183.3070009@cogentembedded.com>
Date: Fri, 25 Apr 2014 21:55:15 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 04/18] xhci-platform: Add a new controller using xhci:
 Armada 38x
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com> <1398434836-18908-5-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1398434836-18908-5-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04/25/2014 06:07 PM, Gregory CLEMENT wrote:

> Extend the compatible string list with armada-380-xhci. It is used to
> describe xhci controller which is in the Armada 38x SoCs.

> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>   Documentation/devicetree/bindings/usb/usb-xhci.txt | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

> diff --git a/Documentation/devicetree/bindings/usb/usb-xhci.txt b/Documentation/devicetree/bindings/usb/usb-xhci.txt
> index 90f8f607d125..cbc91414fd59 100644
> --- a/Documentation/devicetree/bindings/usb/usb-xhci.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-xhci.txt
> @@ -1,7 +1,8 @@
>   USB xHCI controllers
>
>   Required properties:
> -  - compatible: should be "generic-xhci" (deprecated: "xhci-platform").
> +  - compatible: should be on of "generic-xhci",

    s/on/one/

> +    "marvell,armada-380-xhci" (deprecated: "xhci-platform").

    What's the difference of "marvell,armada-380-xhci" to "generic-xhci"?

WBR, Sergei

