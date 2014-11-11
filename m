Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaKKR6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:58:08 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56675 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaKKR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:58:04 -0500
Date: Tue, 11 Nov 2014 17:57:42 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Johan Hovold <johan@kernel.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 19/22] dt/bindings: add micrel,rmii_ref_clk_sel_25_mhz to
 eth-phy binding
Message-ID: <20141111175741.GF25295@leverpostej>
References: <1415727460-20417-1-git-send-email-johan@kernel.org>
 <1415727460-20417-20-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415727460-20417-20-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 05:37:37PM +0000, Johan Hovold wrote:
> Add "micrel,rmii_ref_clk_sel_25_mhz" to Micrel ethernet PHY binding
> documentation.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/micrel.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
> index a1bab5eaae02..9b08dd6551dd 100644
> --- a/Documentation/devicetree/bindings/net/micrel.txt
> +++ b/Documentation/devicetree/bindings/net/micrel.txt
> @@ -19,6 +19,11 @@ Optional properties:
>  
>                See the respective PHY datasheet for the mode values.
>  
> + - micrel,rmii_ref_clk_sel_25_mhz: rmii_ref_clk_sel bit selects 25 MHz mode
> +
> +		Whether 25 MHz (rather than 50 Mhz) clock mode is selected
> +		when the rmii_ref_clk_sel bit is set.

s/_/-/ in property names please.

That said, I don't follow the meaning. Does this cause the kernel to do
something different, or is is simply that a 25MHz ref clock is wired up?

Surely that should be described via the common clock bindings? Or if
internal through a clock-frequency property?

Mark.
