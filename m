Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbaGWWhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:37:47 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:52069 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635AbaGWWhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:37:45 -0400
Date: Thu, 24 Jul 2014 00:32:35 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Benoit Masson <yahoo@perenite.com>
Cc: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 1/2] Adding Lenovo - Lenovo Group Ltd. to the
 vendor-prefixes list.
Message-ID: <20140723223235.GB28485@lunn.ch>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 03:35:22PM -0700, Benoit Masson wrote:
> Lenovo Group Ltd. (stylized as lenovo) is a Chinese multinational computer technology company with headquarters in Beijing, China, and Morrisville, North Carolina, United States.
> 
> http://www.lenovo.com/
> Signed-off-by: Benoit Masson <yahoo@perenite.com>

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew

> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 46a311e..ae09892 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -71,6 +71,7 @@ karo	Ka-Ro electronics GmbH
>  keymile	Keymile GmbH
>  lacie	LaCie
>  lantiq	Lantiq Semiconductor
> +lenovo	Lenovo Group Ltd.
>  lg	LG Corporation
>  linux	Linux-specific binding
>  lsi	LSI Corp. (LSI Logic)
> -- 
> 1.9.1
> 
