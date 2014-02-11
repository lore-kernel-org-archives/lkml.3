Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaBKUUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:20:45 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58703 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbaBKUUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:20:41 -0500
Date: Tue, 11 Feb 2014 12:20:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Wim Van Sebroeck <wim@iguana.be>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 07/11] watchdog: xilinx: Use of_property_read_u32
Message-ID: <20140211202038.GC11798@roeck-us.net>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
 <7aa6e41032ebad0ffb2e1df20beb4f00e38d29e2.1392101734.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aa6e41032ebad0ffb2e1df20beb4f00e38d29e2.1392101734.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 07:55:50AM +0100, Michal Simek wrote:
> Use of_property_read_u32 functions to clean probe function.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
[ ... ]

> +
> +	if (enable_once)
>  		watchdog_set_nowayout(xilinx_wdt_wdd, true);
> -	}

	watchdog_set_nowayout(xilinx_wdt_wdd, enable_once);

would probably do as well (the function checks the flag as well).

Nitpick, so

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
