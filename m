Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298Ab3DCQdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:33:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59470 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758978Ab3DCQdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:33:11 -0400
Date: Wed, 03 Apr 2013 12:33:03 -0400 (EDT)
Message-Id: <20130403.123303.544482473271388131.davem@davemloft.net>
To: kishon@ti.com
Cc: balbi@ti.com, gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org, rob@landley.net,
        sylvester.nawrocki@gmail.com, swarren@wwwdotorg.org, cesarb@cesarb.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, b-cousson@ti.com,
        linux@arm.linux.org.uk, eballetbo@gmail.com, javier@dowhile0.org,
        mchehab@redhat.com, santosh.shilimkar@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/6] Generic PHY Framework
From: David Miller <davem@davemloft.net>
In-Reply-To: <515BCDB2.2040506@ti.com>
References: <515BC559.1070602@ti.com>
	<20130403.023157.1254170239558661397.davem@davemloft.net>
	<515BCDB2.2040506@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 03 Apr 2013 09:33:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>
Date: Wed, 3 Apr 2013 12:05:30 +0530

> This patch series is about drivers/phy which will be used for now by
> usb, sata and maybe some video PHY's. Network itself has a
> comprehensive PHY in drivers/net/phy which we'd like to merge it with
> drivers/phy so that we have all the phy stuff in drivers/phy but we
> are not planning too far ahead here.

Ok, that makes sense, thanks.
