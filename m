Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3FYXey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:34:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35029 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3FYXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:34:53 -0400
Date: Tue, 25 Jun 2013 16:34:52 -0700 (PDT)
Message-Id: <20130625.163452.653163641005496729.davem@davemloft.net>
To: Alexey.Brodkin@synopsys.com
Cc: netdev@vger.kernel.org, andy.shevchenko@gmail.com, romieu@fr.zoreil.com,
        joe@perches.com, Vineet.Gupta1@synopsys.com,
        Mischa.Jonker@synopsys.com, arnd@arndb.de, grant.likely@linaro.org,
        rob.herring@calxeda.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        florian@openwrt.org, david.laight@aculab.com
Subject: Re: [PATCH v8] ethernet/arc/arc_emac - Add new driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372053267-19359-1-git-send-email-abrodkin@synopsys.com>
References: <1372053267-19359-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Date: Mon, 24 Jun 2013 09:54:27 +0400

> Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
> instantiated in some legacy ARC (Synopsys) FPGA Boards such as
> ARCAngel4/ML50x.
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

Applied to net-next, thanks.
