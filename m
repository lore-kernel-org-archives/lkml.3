Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab3HAWwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:52:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55287 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3HAWwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:52:00 -0400
Date: Thu, 01 Aug 2013 15:51:59 -0700 (PDT)
Message-Id: <20130801.155159.1229408467464868669.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, florian@openwrt.org,
        joe@perches.com
Subject: Re: [PATCH v4] net: Add MOXA ART SoCs ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375349968-16059-1-git-send-email-jonas.jensen@gmail.com>
References: <1375280401-5564-1-git-send-email-jonas.jensen@gmail.com>
	<1375349968-16059-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 01 Aug 2013 15:51:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Thu,  1 Aug 2013 11:39:28 +0200

>     I have since found a problem occurring on high load. Please point out
>     anything the driver can do differently to eliminate it.
>     
>     The error only occurs during external ping, i.e. ping -s 50000 from
>     10.0.1.200 to hardware.

Looks like pure memory corruption.
