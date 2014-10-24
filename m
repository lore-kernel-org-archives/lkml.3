Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaJXGKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:10:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46890 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaJXGKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:10:14 -0400
Date: Fri, 24 Oct 2014 02:10:09 -0400 (EDT)
Message-Id: <20141024.021009.1407162505438540933.davem@davemloft.net>
To: linux@roeck-us.net
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
From: David Miller <davem@davemloft.net>
In-Reply-To: <5449E66B.6090902@roeck-us.net>
References: <54488CE1.2000106@roeck-us.net>
	<20141024.010306.1939269479587208896.davem@davemloft.net>
	<5449E66B.6090902@roeck-us.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Oct 2014 23:10:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Thu, 23 Oct 2014 22:40:59 -0700

> I see two options for that:
> 
> - Add
> 	select HWMON
>   to the NET_DSA Kconfig entry.
>   Example is Broadcom TIGON3 driver.
> 
> - Add a DSA_HWMON Kconfig entry to define the dependencies and
>   to let the user select if the functionality should be enabled.
>   Example is Intel IGB driver.
> 
> Any preference from your side ? If no, I'll go with the latter.

Probably the latter is better, select can get you into trouble.
