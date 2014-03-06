Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaCFSRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:17:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59664 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaCFSRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:17:53 -0500
Date: Thu, 06 Mar 2014 13:17:51 -0500 (EST)
Message-Id: <20140306.131751.1208829414159301842.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8152: cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394089638-1580-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	<1394089638-1580-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 10:17:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 6 Mar 2014 15:07:15 +0800

> Deal with some empty lines and spaces, replace some tp->netdev with netdev,
> and remove the unnecessary function.

Series applied, thank you.
