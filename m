Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaBNUOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:14:16 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59130 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaBNUON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:14:13 -0500
Date: Fri, 14 Feb 2014 12:14:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Chew <achew@nvidia.com>
Cc: wim@iguana.be, rob@landley.net, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        abrestic@chromium.org, dgreid@chromium.org, katierh@chromium.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 1/1] watchdog: Add tegra watchdog
Message-ID: <20140214201409.GA31748@roeck-us.net>
References: <1392408185-15387-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392408185-15387-1-git-send-email-achew@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, Feb 14, 2014 at 12:03:05PM -0800, Andrew Chew wrote:
> Add a driver for the hardware watchdogs in NVIDIA Tegra SoCs (Tegra30 and
> later).  This driver will configure one watchdog timer that will reset the
> system in the case of a watchdog timeout.
> 
> This driver binds to the nvidia,tegra30-timer device node and gets its
> register base from there.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from v6:
> 
> Removed kref stuff.  We can't think of why it's needed here.
> 

Me likes that :-)

Many changes since my original review, but I re-confirm my Reviewed-by: above.

Guenter
