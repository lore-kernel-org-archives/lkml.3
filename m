Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbaFLJoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:44:38 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55432 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932972AbaFLJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:44:36 -0400
Date: Thu, 12 Jun 2014 10:44:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        antoine.tenart@free-electrons.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: berlin2q.dtsi: set L2CC tag and data latency
	as 2 cycles
Message-ID: <20140612094423.GC23430@n2100.arm.linux.org.uk>
References: <1402565920-5636-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402565920-5636-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:38:40PM +0800, Jisheng Zhang wrote:
> For all BG2Q SoCs, 2 cycles is the best/correct value

It would be a good idea to set all these parameters if you need to set
them at all - in other words, setting arm,dirty-latency as well, as
that's all part of the timing specification.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
