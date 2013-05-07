Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab3EGJSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:18:07 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:43521 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277Ab3EGJSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:18:04 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 05:18:04 EDT
Message-ID: <5188C500.8010209@keymile.com>
Date: Tue, 07 May 2013 11:10:24 +0200
From: Valentin Longchamp <valentin.longchamp@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] mv643xx_eth: device tree bindings
References: <1365071235-11611-1-git-send-email-florian@openwrt.org> <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On 05/06/2013 05:33 PM, Sebastian Hesselbarth wrote:
> This patch set picks up work by Florian Fainelli bringing full DT
> support to mv643xx_eth and Marvell SoCs using it.
> 
> The current patch set drops Florian's device tree conversions for
> Kirkwood, Dove, and Orion5x in favour of split patches for board
> files and board descriptor files.
> 
> Device tree conversion for Dove and Kirkwood is added. Dove has
> been fully tested, while Kirkwood is compile-tested only.
> 
> Florian Fainelli (2):
>   net: mv643xx_eth: add Device Tree bindings
>   net: mv643xx_eth: update Device Tree bindings documentation
> 
> Sebastian Hesselbarth (5):
>   ARM: dove: remove legacy mv643xx_eth setup
>   ARM: dove: add gigabit ethernet and mvmdio device tree nodes
>   ARM: kirkwood: remove legacy mv643xx_eth board setup
>   ARM: kirkwood: add gigabit ethernet and mvmdio device tree nodes
>   ARM: kirkwood: remove legacy clk alias for mv643xx_eth
> 

I have successfully tested these patches on km_kirkwood, you can add my tested-by:

Tested-by: Valentin Longchamp<valentin.longchamp@keymile.com>
