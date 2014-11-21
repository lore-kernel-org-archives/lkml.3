Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaKUTxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:53:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38129 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaKUTxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:53:37 -0500
Date: Fri, 21 Nov 2014 14:53:34 -0500 (EST)
Message-Id: <20141121.145334.65720125038869042.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/2] r8152: adjust rx functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-98-Taiwan-albertk@realtek.com>
References: <1394712342-15778-88-Taiwan-albertk@realtek.com>
	<1394712342-15778-98-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 11:53:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 20 Nov 2014 10:29:04 +0800

> v3:
> For patch #1, remove unnecessary initialization for ret and
> unnecessary blank line in r8152_submit_rx().
> 
> v2:
> For patch #1, set actual_length to 0 before adding the rx to the
> list, when a error occurs.
> 
> For patch #2, change the flow. Stop submitting the rx if a error
> occurs, and add the remaining rx to the list for submitting later.
> 
> v1:
> Adjust some flows and codes which are relative to r8152_submit_rx()
> and rtl_start_rx().

Series applied, thanks.
