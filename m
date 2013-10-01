Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab3JAFK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 01:10:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42629 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3JAFKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 01:10:25 -0400
Date: Mon, 30 Sep 2013 22:17:31 -0700 (PDT)
Message-Id: <20130930.221731.1527688326511547313.davem@davemloft.net>
To: b.zolnierkie@samsung.com
Cc: jonas.jensen@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] ethernet: moxa: fix incorrect placement of __initdata
 tag
From: David Miller <davem@davemloft.net>
In-Reply-To: <172588984.DhoE4BmVdc@amdc1032>
References: <172588984.DhoE4BmVdc@amdc1032>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 30 Sep 2013 22:10:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 30 Sep 2013 15:18:27 +0200

> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.
> 
> In this particular case __initdata is incorrect as moxart_mac_driver
> can be used after the driver gets initialized.
> 
> Also while at it static-ize moxart_mac_driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied, thanks.
