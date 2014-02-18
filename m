Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBRVlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:41:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36118 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaBRVlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:41:03 -0500
Date: Tue, 18 Feb 2014 16:41:01 -0500 (EST)
Message-Id: <20140218.164101.1698700144741352599.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 00/14] r8152: improvement and new features
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2014 13:41:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 18 Feb 2014 21:48:57 +0800

> Change some flows or behavior to improve the efficiency or make the
> code readable. Besides, support WOL and runtime suspend.

Series applied, but as Florian mentioned you should seriously consider
converting this driver to use phylib.
