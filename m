Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbaGWWrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:47:47 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:52088 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbaGWWrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:47:46 -0400
Date: Thu, 24 Jul 2014 00:42:36 +0200
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
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140723224236.GC28485@lunn.ch>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
 <1406154923-13612-2-git-send-email-yahoo@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406154923-13612-2-git-send-email-yahoo@perenite.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +			i2c@11000 {
> +				compatible = "marvell,mv78230-a0-i2c",
> +					"marvell,mv64xxx-i2c";

Ah sorry, i missed this first time. Do you really need
"marvell,mv78230-a0-i2c"?

Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt says:

                     - "marvell,mv78230-a0-i2c"
                       * Note: Only use "marvell,mv78230-a0-i2c" for a
                         very rare, initial version of the SoC which
                         had broken offload support.  Linux
                         auto-detects this and sets it appropriately.

So i don't think you should have this hear.

Gregory, please could you comment.

> +		power-led {
> +			label = "ix4-300d:power";

It is normal to include the colour, and you did for all the other
LEDs.

	Andrew
