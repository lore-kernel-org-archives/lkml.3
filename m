Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaBJSqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:46:22 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:47718 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbaBJSqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:46:19 -0500
Date: Mon, 10 Feb 2014 19:46:05 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Stefan =?iso-8859-1?Q?S=F8rensen?= 
	<stefan.sorensen@spectralink.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dp83640: Get gpio and master/slave configuration from DT
Message-ID: <20140210184604.GA4296@netboy>
References: <1392037240-30913-1-git-send-email-stefan.sorensen@spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392037240-30913-1-git-send-email-stefan.sorensen@spectralink.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:00:40PM +0100, Stefan Sørensen wrote:
> This patch removes the module parameters gpio_tab and chosen_phy in favour of
> retrieving the configuration from DT through the properties

Can we please keep the module parameters? I have two platforms with
phyters neither of which will ever support DT, namely ixp and m68k,
and I want to run recent kernels on them.

Are module parameters even considered user ABI?

Even if not, still I want to retain the module params until there is
an alternative for non-DT platforms.

> 	dp83640,slave
> 	dp83640,calibrate-gpio
> 	dp83640,perout-gpios
> 	dp83640,extts-gpios
> The configuration is now stored for each master clock device, allowing different 
> gpio setups for each master.

What do you mean by "each master"? Do you mean each individual PHY device
or each group of PHYs on the same MDIO bus?

Thanks,
Richard
