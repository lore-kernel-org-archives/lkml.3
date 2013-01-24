Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3AXH2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:28:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3AXH2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:28:11 -0500
Date: Thu, 24 Jan 2013 08:28:04 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@nvidia.com, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: add support for Tegra114 SoC
Message-ID: <20130124072804.GL8364@nekote.pengutronix.de>
References: <1357387486-25966-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357387486-25966-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 05:34:46PM +0530, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has following enhanced feature in i2c controller:
> - Enable/disable control for per packet transfer complete interrupt.
>   Earlier SoCs could not disable this.
> - Single clock source for standard/fast and HS mode clock speed.
>   The clock divisor for fast/standard mode is added into the i2c
>   controller to meet the HS and standard/fast mode of clock speed
>   from single source.
> 
> Add support for the above feature to make it functional on T114 SOCs.

Thanks, applied to next.

