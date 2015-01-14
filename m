Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbbANQWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:22:07 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39944 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753796AbbANQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:22:04 -0500
Date: Wed, 14 Jan 2015 16:21:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        lauraa@codeaurora.org, tony@atomide.com, linus.walleij@linaro.org,
        Tomasz Figa <tomasz.figa@gmail.com>, drake@endlessm.com,
        loeliger@gmail.com, Kyungmin Park <kyungmin.park@samsung.com>,
        santosh.shilimkar@ti.com, linux-omap@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Message-ID: <20150114162150.GQ11502@n2100.arm.linux.org.uk>
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
 <20150114154603.GK3843@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114154603.GK3843@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 04:46:03PM +0100, Alexandre Belloni wrote:
> Hi,
> 
> This patch set hasn't moved since while. We actually need patch 4 to
> properly configure prefetch on sama5d4. What would be needed to come to
> an agreement ?

What do you mean "hasn't moved since a while" - there has been movement.
It was discovered that it breaks OMAP4 platforms.

Since then, work has been done to resolve that breakage, and I've merged
the recent patch set into my tree for further regression testing, and
I'm going to push it out to linux-next later this week.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
