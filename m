Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaHCDnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 23:43:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51416 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHCDnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 23:43:16 -0400
Date: Sat, 02 Aug 2014 20:43:14 -0700 (PDT)
Message-Id: <20140802.204314.1746432025847155966.davem@davemloft.net>
To: himangi774@gmail.com
Cc: f.fainelli@gmail.com, paul.gortmaker@windriver.com, p.zabel@pengutronix.de,
        jg1.han@samsung.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] net: phy: spi_ks8995: Introduce the use of devm_kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140802221021.GA18205@himangi-Dell>
References: <20140802221021.GA18205@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 20:43:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please submit networking patches at least CC:'d to netdev@vger.kernel.org,
thank you.
