Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaBJRyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:54:18 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:54198 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbaBJRyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:54:16 -0500
Date: Mon, 10 Feb 2014 18:53:50 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 6/6] dt: Update binding information for mvebu gating
 clocks with Armada 380/385
Message-ID: <20140210175350.GD9995@lunn.ch>
References: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
 <1392053569-28037-7-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392053569-28037-7-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +The following is a list of provided IDs for Armada 380/385:
> +ID	Clock		Peripheral
> +-----------------------------------
> +0	audio		Audio
> +2	ge2		Gigabit Ethernet 2
> +3	ge1		Gigabit Ethernet 1
> +4	ge0		Gigabit Ethernet 0
> +5	pex1		PCIe 1
> +6	pex2		PCIe 2
> +7	pex3		PCIe 3
> +8	pex4		PCIe 0

Is that last one a typo? It at least looks a bit odd.

Thanks
	Andrew

