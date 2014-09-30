Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaI3Uph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:45:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49671 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaI3Upf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:45:35 -0400
Date: Tue, 30 Sep 2014 16:45:33 -0400 (EDT)
Message-Id: <20140930.164533.2014251085729375033.davem@davemloft.net>
To: hau@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 08/10] r8169:change function name of function
 "r8168dp_check_dash" to "r8168_check_dash"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412089230-10208-8-git-send-email-hau@realtek.com>
References: <1412089230-10208-1-git-send-email-hau@realtek.com>
	<1412089230-10208-8-git-send-email-hau@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 13:45:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chun-Hao Lin <hau@realtek.com>
Date: Tue, 30 Sep 2014 23:00:28 +0800

> @@ -4364,7 +4364,7 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
>  	if ((tp->mac_version == RTL_GIGA_MAC_VER_27 ||
>  	     tp->mac_version == RTL_GIGA_MAC_VER_28 ||
>  	     tp->mac_version == RTL_GIGA_MAC_VER_31) &&
> -	    r8168dp_check_dash(tp)) {
> +	     r8168_check_dash(tp)) {

You are breaking the indentation here, "r8169_check_dash..." should start exactly
at the first column after the openning parenthesis of the if() statement.

So that's a TAB and four SPACE characters, not five SPACE characters.
