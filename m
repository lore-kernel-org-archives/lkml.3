Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaDCPMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:12:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44823 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaDCPMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:12:31 -0400
Date: Thu, 03 Apr 2014 11:14:01 -0400 (EDT)
Message-Id: <20140403.111401.1679730754008116799.davem@davemloft.net>
To: holler@ahsoftware.de
Cc: sebastian.hesselbarth@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        michal.simek@xilinx.com, stable@vger.kernel.org
Subject: Re: [PATCH regression] net: phy: fix initialization (config_init)
 for Marvel 88E1116R PHYs
From: David Miller <davem@davemloft.net>
In-Reply-To: <533D790C.5000104@ahsoftware.de>
References: <533D0B09.9040602@ahsoftware.de>
	<533D207E.9020909@gmail.com>
	<533D790C.5000104@ahsoftware.de>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 08:12:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Holler <holler@ahsoftware.de>
Date: Thu, 03 Apr 2014 17:06:52 +0200

> But don't suggest me (or insist on) a time consuming

Bisects are not time consuming, and help developers analyze your
issue tremendously.
