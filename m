Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbaGWXDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:03:52 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:52108 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbaGWXDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:03:51 -0400
Date: Thu, 24 Jul 2014 00:58:41 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Benoit Masson <benoitm@perenite.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Benoit Masson <yahoo@perenite.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140723225841.GD28485@lunn.ch>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
 <1406154923-13612-2-git-send-email-yahoo@perenite.com>
 <20140723224236.GC28485@lunn.ch>
 <94F87063-D717-435B-B7C5-EDAC9B26742C@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94F87063-D717-435B-B7C5-EDAC9B26742C@perenite.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For the marvell,mv78230-a0-i2c unfortunately i've spend 3 hours
> trying to understand this but it only works with this on the
> ix4-300d :(. There was multiple patch around this and maybe one
> broke the auto-detect part of this, I've tried compiling with some
> 3.10 or lower kernel but no luck here I still have to put this a0
> option.

Lets first confirm you have an a0 SoC.

At boot time, it should print:

pr_info("MVEBU SoC ID=0x%X, Rev=0x%X\n", soc_dev_id, soc_rev);

What revision do you have?

If the auto detect code really is broken, Gregory will likely take a
look.

	Andrew
