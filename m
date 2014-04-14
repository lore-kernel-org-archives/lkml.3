Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaDNT6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:58:11 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34068 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752074AbaDNT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:58:03 -0400
Date: Mon, 14 Apr 2014 20:57:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 0/7] Reorder i.MX IPU display enable/disable sequence
Message-ID: <20140414195718.GK24070@n2100.arm.linux.org.uk>
References: <1397488895-17930-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397488895-17930-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 05:21:28PM +0200, Philipp Zabel wrote:
> Repeatedly enabling and disabling the display currently can lead to a state
> in which the IPU doesn't produce a valid signal anymore because we disable
> IPU submodules before they can finish their interaction.

Well done at finding the cause of this - I've encounted this several
times, while testing imx-hdmi and it's good that it should hopefully
be fixed!

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
