Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaHSLWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:22:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61633 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbaHSLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:22:34 -0400
Date: Tue, 19 Aug 2014 12:22:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Pavel Machek <pavel@denx.de>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "dinguyen@altera.com" <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH] stmmac.txt: fix typo
Message-ID: <20140819112214.GI3302@leverpostej>
References: <20140818215928.GA4400@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818215928.GA4400@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:59:28PM +0100, Pavel Machek wrote:
> Fix typo in devicetree example.
>     
> Signed-off-by: Pavel Machek <pavel@denx.de>

Looks sane to me:

Acked-by: Mark Rutland <mark.rutland@arm.com>

> 
> diff --git a/Documentation/devicetree/bindings/net/stmmac.txt b/Documentation/devicetree/bindings/net/stmmac.txt
> index f319112..4012b5c 100644
> --- a/Documentation/devicetree/bindings/net/stmmac.txt
> +++ b/Documentation/devicetree/bindings/net/stmmac.txt
> @@ -49,5 +49,5 @@ Examples:
>  		max-frame-size = <3800>;
>  		phy-mode = "gmii";
>  		clocks = <&clock>;
> -		clock-names = "stmmaceth">;
> +		clock-names = "stmmaceth";
>  	};
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
