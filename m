Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3K3RFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:05:53 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17201 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3K3RFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:05:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+TePtv+6POkzdCPmFM3TEu
Date: Sat, 30 Nov 2013 09:05:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 1/3] pinctrl: single: fix DT bindings documentation
Message-ID: <20131130170548.GA23334@atomide.com>
References: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [131128 03:30]:
> Remove extra comma in pinctrl-single documentation.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> index 7069a0b84e3a..bc0dfdfdb148 100644
> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> @@ -98,7 +98,7 @@ below for more information.
>  In case when one register changes more than one pin's mux the
>  pinctrl-single,bits need to be used which takes three parameters:
>  
> -	pinctrl-single,bits = <0xdc 0x18, 0xff>;
> +	pinctrl-single,bits = <0xdc 0x18 0xff>;
>  
>  Where 0xdc is the offset from the pinctrl register base address for the
>  device pinctrl register, 0x18 is the desired value, and 0xff is the sub mask to
> -- 
> 1.8.3.2
> 
