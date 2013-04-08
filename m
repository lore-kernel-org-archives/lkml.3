Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136Ab3DHU4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:56:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52847 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892Ab3DHU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:56:51 -0400
Date: Mon, 08 Apr 2013 16:56:50 -0400 (EDT)
Message-Id: <20130408.165650.1844719222601323138.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: florian@openwrt.org, thomas.petazzoni@free-electrons.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvmdio: get and enable optional clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365332988-9053-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365332988-9053-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 13:56:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Sun,  7 Apr 2013 13:09:47 +0200

> Marvell mdio driver uses internal registers that can be clock gated on
> some SoCs. This patch just adds optional clock handling, to allow to pass
> and enable the corresponding clock.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied.
