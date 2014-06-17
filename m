Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967676AbaFQWbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:31:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57301 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966657AbaFQWbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:31:37 -0400
Date: Tue, 17 Jun 2014 15:31:36 -0700 (PDT)
Message-Id: <20140617.153136.653057237840817486.davem@davemloft.net>
To: varkabhadram@gmail.com
Cc: netdev@vger.kernel.org, alex.bluesman.smirnov@gmail.com,
        dbaryshkov@gmail.com, linux-zigbee-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, varkab@cdac.in
Subject: Re: [PATCH net-next] mrf24j40: separate h/w init and add checkings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402890152-2803-1-git-send-email-varkab@cdac.in>
References: <1402890152-2803-1-git-send-email-varkab@cdac.in>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Jun 2014 15:31:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>
Date: Mon, 16 Jun 2014 09:12:31 +0530

> separate the mrf24j40 hardware initialisation from probe()
> and adds the sanity checkings.
> 
> These checkings are required if somebody hasn't a right spi configuration
> the probe function should fail. So we have to return from there.
> 
> Signed-off-by: Varka Bhadram <varkab@cdac.in>

Applied.
