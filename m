Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaFLSD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:03:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53381 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaFLSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:03:25 -0400
Date: Thu, 12 Jun 2014 11:03:24 -0700 (PDT)
Message-Id: <20140612.110324.932062947770396872.davem@davemloft.net>
To: varkabhadram@gmail.com
Cc: netdev@vger.kernel.org, alex.bluesman.smirnov@gmail.com,
        dbaryshkov@gmail.com, linux-zigbee-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, varkab@cdac.in
Subject: Re: [PATCH net-next] mrf24j40: separate h/w init and add checkings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402564248-20606-1-git-send-email-varkab@cdac.in>
References: <1402564248-20606-1-git-send-email-varkab@cdac.in>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Jun 2014 11:03:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>
Date: Thu, 12 Jun 2014 14:40:48 +0530

> separate the mrf24j40 hardware initialisation from probe()
> and adds the sanity checkings.
> 
> These checkings are required if somebody hasn't a right spi configuration 
> the probe function should fail. So we have to return from there.
> 
> Signed-off-by: Varka Bhadram <varkab@cdac.in>

Applied, thanks.
