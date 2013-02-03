Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3BCDZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:25:20 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58725 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3BCDZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:25:17 -0500
Date: Sat, 2 Feb 2013 19:21:30 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
Cc: linus.walleij@stericsson.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH] ab8500: btemp: demote initcall sequence
Message-ID: <20130203032130.GB25016@lizard.sbx00618.mountca.wayport.net>
References: <1358915205-7786-1-git-send-email-rajanikanth.hv@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1358915205-7786-1-git-send-email-rajanikanth.hv@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 09:56:45AM +0530, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> Power supply subsystem creates thermal zone device for
> the property 'POWER_SUPPLY_PROP_TEMP' which requires
> thermal subsystem to be ready before 'ab8500 battery temperature monitor'
> driver is initialized.
> ab8500 btemp driver is initialized with subsys_initcall whereas thermal
> subsystem is initialized with fs_initcall which causes
> thermal_zone_device_register(...) to crash since the required structure
> 'thermal_class' is not initialized yet.
> 
> crash log:
[...]
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
> ---

Applied and added Cc: stable.

Thanks!
