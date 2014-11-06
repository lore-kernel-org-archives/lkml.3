Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaKFUPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:15:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58328 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaKFUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:15:29 -0500
Date: Thu, 06 Nov 2014 15:15:26 -0500 (EST)
Message-Id: <20141106.151526.1810370548228119689.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8152: rtl_ops_init modify
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-84-Taiwan-albertk@realtek.com>
References: <1394712342-15778-84-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Nov 2014 12:15:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 6 Nov 2014 12:47:37 +0800

> Initialize the ops through tp->version. This could skip checking
> each VID/PID.

Series applied, thank you.
