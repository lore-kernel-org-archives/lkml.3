Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845Ab3DCGcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:32:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53266 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762804Ab3DCGcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:32:04 -0400
Date: Wed, 03 Apr 2013 02:31:57 -0400 (EDT)
Message-Id: <20130403.023157.1254170239558661397.davem@davemloft.net>
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
In-Reply-To: <515BC559.1070602@ti.com>
References: <1364449408-9510-1-git-send-email-kishon@ti.com>
	<20130328.143142.2080627792603647441.davem@davemloft.net>
	<515BC559.1070602@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 02 Apr 2013 23:32:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>
Date: Wed, 3 Apr 2013 11:29:53 +0530

> Hi,
> 
> On Friday 29 March 2013 12:01 AM, David Miller wrote:
>>
>> You really need to CC: netdev@vger.kernel.org rather than me
>> explicitly
>> on this patch set.
> 
> I was CC'ing whatever get_maintainer shows. I'll make sure to CC
> netdev@vger.kernel.org though there's nothing related to network in
> this patch series (Maybe sometime in the future it'll be used).

What about drivers/net/phy isn't networking?
