Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762334Ab3DBUoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:44:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46812 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761983Ab3DBUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:44:38 -0400
Date: Tue, 02 Apr 2013 16:44:35 -0400 (EDT)
Message-Id: <20130402.164435.394488805917592019.davem@davemloft.net>
To: linux@roeck-us.net
Cc: nicolas.ferre@atmel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, david.daney@cavium.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 0/5] Provide empty functions if OF_NET is not configured
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
References: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 02 Apr 2013 13:44:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Tue,  2 Apr 2013 12:35:06 -0700

> Provide empty functions for of_get_phy_mode() and of_get_mac_address()
> if OF_NET is not configured. Modify affected drivers to rely on the
> now available functions.

All applied, but please post your patches against the appropriate
tree.

In net-next, fec.c has been renamed to fec_main.c so I had to adjust
your patch so that it would apply correctly.
