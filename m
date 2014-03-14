Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaCNEHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 00:07:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58899 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaCNEHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 00:07:45 -0400
Date: Fri, 14 Mar 2014 00:07:41 -0400 (EDT)
Message-Id: <20140314.000741.1829674011496195593.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: David.Laight@ACULAB.COM, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] r8152:
 addRTL8152_EARLY_AGG_TIMEOUT_SUPER
From: David Miller <davem@davemloft.net>
In-Reply-To: <A56A13416A724183888BB62CEFD2B817@realtek.com.tw>
References: <063D6719AE5E284EB5DD2968C1650D6D0F6DCB6E@AcuExch.aculab.com>
	<20140313.132222.536931544768069240.davem@davemloft.net>
	<A56A13416A724183888BB62CEFD2B817@realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Mar 2014 21:07:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hayeswang <hayeswang@realtek.com>
Date: Fri, 14 Mar 2014 10:37:21 +0800

>  From: David Miller [mailto:davem@davemloft.net] 
>  Sent: Friday, March 14, 2014 1:22 AM
> [...]
>> And I fundamentally disagree with this being a Kconfig parameter.
>> 
>> Make it run-time calculated _or_ settable via ethtool.
> 
> Excuse me. How should I make it run-time calculated without a
> Kconfig parameter? Should I use module_param? 

You run-time determine the setting based upon the negotiated link
speed and traffic patterns.
