Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaGKVdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:33:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaGKVds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:33:48 -0400
Date: Fri, 11 Jul 2014 14:33:47 -0700 (PDT)
Message-Id: <20140711.143347.149690194502074107.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nic_swsd@realtek.com
Subject: Re: [PATCH net-next 0/3] r8169: support IPv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-10-Taiwan-albertk@realtek.com>
References: <1394712342-15778-10-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Jul 2014 14:33:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 11 Jul 2014 16:25:55 +0800

> The RTL8168C and the later chips support the hardware checksum
> for IPv6. Adjust some code and add the relative code.

Series applied, thanks.
