Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3HFIll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:41:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42189 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781Ab3HFIli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:41:38 -0400
Date: Tue, 6 Aug 2013 09:41:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 2/2] pinctrl: add generic pins and functions properties
Message-ID: <20130806084131.GB23111@e106331-lin.cambridge.arm.com>
References: <1375739760-18833-1-git-send-email-swarren@wwwdotorg.org>
 <1375739760-18833-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375739760-18833-2-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:56:00PM +0100, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> pinctrl bindings can benefit from generic property names that define
> which pins a "pin configuration node" affects, and which mux function
> to select onto those pins. Document new properties for this purpose so
> that other bindings may refer to them.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> index 31b0cb9..237823a 100644
> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> @@ -138,6 +138,9 @@ structure of the DT nodes that contain these properties.
>  
>  Supported generic properties are:
>  
> +pins			- the list of pins that properties in the node
> +			  apply to
> +function		- the mux function to select

I assume the type of these properties must be described in the more
specific binding?

Mark.

>  bias-disable		- disable any pin bias
>  bias-high-impedance	- high impedance mode ("third-state", "floating")
>  bias-bus-hold		- latch weakly
> -- 
> 1.8.1.5
> 
> 
