Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423640Ab3FUSYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:24:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34794 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423383Ab3FUSYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:24:06 -0400
Date: Fri, 21 Jun 2013 11:27:29 -0700 (PDT)
Message-Id: <20130621.112729.1807883476742785070.davem@davemloft.net>
To: joe@perches.com
Cc: Alexey.Brodkin@synopsys.com, netdev@vger.kernel.org,
        andy.shevchenko@gmail.com, romieu@fr.zoreil.com,
        Vineet.Gupta1@synopsys.com, Mischa.Jonker@synopsys.com, arnd@arndb.de,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, florian@openwrt.org
Subject: Re: [PATCH v7] ethernet/arc/arc_emac - Add new driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371825813.19215.34.camel@joe-AO722>
References: <1371810775.19215.30.camel@joe-AO722>
	<4881796E12491D4BB15146FE0209CE643F5F587E@DE02WEMBXB.internal.synopsys.com>
	<1371825813.19215.34.camel@joe-AO722>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 21 Jun 2013 07:43:33 -0700

> Maybe add a Kconfig "depends on !64BIT".

Please, no.
