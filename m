Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaGQFYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 01:24:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57448 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaGQFYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 01:24:16 -0400
Date: Wed, 16 Jul 2014 22:24:15 -0700 (PDT)
Message-Id: <20140716.222415.728402505581829764.davem@davemloft.net>
To: michel@daenzer.net
Cc: nic_swsd@realtek.com, romieu@fr.zoreil.com, hayeswang@realtek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405569340-31507-1-git-send-email-michel@daenzer.net>
References: <20140716.202945.2231269352453909430.davem@davemloft.net>
	<1405569340-31507-1-git-send-email-michel@daenzer.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Jul 2014 22:24:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Dänzer <michel@daenzer.net>
Date: Thu, 17 Jul 2014 12:55:40 +0900

> The ethernet port on my ASUS A88X Pro mainboard stopped working
> several times a day, with messages like these in dmesg:
> 
> AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 domain=0x001e address=0x0000000000003000 flags=0x0050]
> 
> Searching the web for these messages led me to similar reports about
> different hardware supported by r8169, and eventually to commits
> 3ced8c955e74d319f3e3997f7169c79d524dfd06 ('r8169: enforce RX_MULTI_EN
> for the 8168f.') and eb2dc35d99028b698cdedba4f5522bc43e576bd2 ('r8169:
> RxConfig hack for the 8168evl'). So I tried this change, and it fixes
> the problem for me.
> 
> Signed-off-by: Michel Dänzer <michel@daenzer.net>
> ---
> 
> v2: Updated commit log, how about this?

Works for me, applied, thanks.
