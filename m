Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaHYHA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:00:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55471 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaHYHA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:00:27 -0400
Date: Mon, 25 Aug 2014 00:00:24 -0700 (PDT)
Message-Id: <20140825.000024.370420105630387444.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] r8152: firmware support
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB25161DF@RTITMBSV03.realtek.com.tw>
References: <0835B3720019904CB8F7AA43166CEEB2516177@RTITMBSV03.realtek.com.tw>
	<20140824.212614.2300459100680592586.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB25161DF@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 00:00:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 25 Aug 2014 06:43:02 +0000

> Except the step 3, 4, 6 and 7, the other steps depend on the
> context of the firmware. That is, for different firmware, some
> actions would be removed or added, and some settings would be
> different. Especially the step 8, it often different for
> different firmwares. Should I add some firmware version check
> in the source code?

This is extremely poor design of the firmware, adding such constantly
changing dependencies and constantly changing programming sequences
just to get the firmare executing is a terrible idea.

You really need to sanitize this in some way, because what you have
posted is totally unacceptable to me.
