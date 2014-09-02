Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaIBUXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:23:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58203 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbaIBUXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:23:48 -0400
Date: Tue, 02 Sep 2014 13:23:47 -0700 (PDT)
Message-Id: <20140902.132347.188427730342673429.davem@davemloft.net>
To: b.zolnierkie@samsung.com
Cc: robh@kernel.org, kyungmin.park@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: calxedaxgmac: fix driver dependencies
From: David Miller <davem@davemloft.net>
In-Reply-To: <7268934.nBXHizFkl4@amdc1032>
References: <7268934.nBXHizFkl4@amdc1032>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Sep 2014 13:23:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 01 Sep 2014 17:39:04 +0200

> Calxeda 1G/10G XGMAC Ethernet support should be available only on
> Calxeda ECX-1000/2000 (Highbank/Midway) platforms.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied.
