Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbaAFVPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:15:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34723 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaAFVPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:15:41 -0500
Date: Mon, 06 Jan 2014 16:15:38 -0500 (EST)
Message-Id: <20140106.161538.1950437782278389932.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] adjust the code of r8152
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388999323-9059-1-git-send-email-hayeswang@realtek.com>
References: <1388990366-8508-1-git-send-email-hayeswang@realtek.com>
	<1388999323-9059-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 13:15:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 6 Jan 2014 17:08:40 +0800

> Replace some tabs and modify the return value of rtl_ops_init().
> 
> v2: add the terminating newline for the message of patch #3.

Series applied.
