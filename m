Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036AbaABDzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 22:55:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46254 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaABDzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 22:55:23 -0500
Date: Wed, 01 Jan 2014 22:55:21 -0500 (EST)
Message-Id: <20140101.225521.752529400795501020.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] support new chip
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388632963-1341-1-git-send-email-hayeswang@realtek.com>
References: <1388111649-1014-1-git-send-email-hayeswang@realtek.com>
	<1388632963-1341-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 01 Jan 2014 19:55:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 2 Jan 2014 11:22:38 +0800

> Remove the trailing "/* CRC */" for patch #3.
> 
> Change the return value type of rtl_ops_init() from int to boolean
> for patch #4.
> 
> Replace VENDOR_ID_SAMSUNG with SAMSUNG_VENDOR_ID for patch #6.

Series applied, thank you.
