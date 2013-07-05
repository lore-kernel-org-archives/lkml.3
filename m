Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3GEVBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:01:23 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:53933 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750937Ab3GEVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:01:21 -0400
Date: Fri, 5 Jul 2013 23:01:19 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        guenter@roeck-us.net
Subject: Re: [PATCH RESEND v10 1/2] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130705210119.GA10354@spo001.leaseweb.com>
References: <20130617140019.GA23794@roeck-us.net> <20130618151939.GA23296@jtlinux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618151939.GA23296@jtlinux>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> This patch adds the driver for the watchdog devices found on MEN Mikro
> Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
> watchdog framework.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

I added this patch to linux-watchdog-next.
I am still thinking about wether or not we shouldn't add a timer to this
watchdog device driver. But that's something we can change later on.

Kind regards,
Wim.

