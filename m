Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3HFBvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:51:53 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64679 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3HFBvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:51:52 -0400
Date: Mon, 5 Aug 2013 18:51:48 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] MAINTAINERS: drivers/power: add entry for SmartReflex
 AVS drivers
Message-ID: <20130806015147.GA16668@teo>
References: <1375720177-20063-1-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1375720177-20063-1-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 09:29:37AM -0700, Kevin Hilman wrote:
> The SmartReflex AVS driver evolved out of the OMAP kernel and now
> lives under drivers/power/avs.
> 
> I've historically been maintainer of this but Nishanth Menon is doing
> most of the heavy lifting now.  Add us both as co-maintainers.
> 
...
> +M:	Kevin Hilman <khilman@kernel.org>
> +M:	Nishanth Menon <nm@ti.com>
> +S:	Maintained
> +F:	drivers/power/avs/smartreflex.c
> +F:      include/linux/power/smartreflex.h

This line is borken (whitespaces).

> +L:	linux-pm@vger.kernel.org
> +
>  PNP SUPPORT
>  M:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>  M:	Bjorn Helgaas <bhelgaas@google.com>
> -- 
> 1.8.3
