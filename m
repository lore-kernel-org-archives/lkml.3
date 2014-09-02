Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaIBUXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:23:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58198 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaIBUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:23:42 -0400
Date: Tue, 02 Sep 2014 13:23:41 -0700 (PDT)
Message-Id: <20140902.132341.1051828958208772118.davem@davemloft.net>
To: b.zolnierkie@samsung.com
Cc: horms@verge.net.au, magnus.damm@gmail.com, kyungmin.park@samsung.com,
        netdev@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sh_eth: fix driver dependencies
From: David Miller <davem@davemloft.net>
In-Reply-To: <1749721.1a6rN6K2Gg@amdc1032>
References: <1749721.1a6rN6K2Gg@amdc1032>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Sep 2014 13:23:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 01 Sep 2014 16:25:35 +0200

> Renesas SuperH Ethernet support should be available only on
> Renesas ARM SoCs and SuperH architecture.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied.
