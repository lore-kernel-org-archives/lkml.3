Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3HOIfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:35:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37829 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3HOIfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 04:35:02 -0400
Date: Thu, 15 Aug 2013 01:35:01 -0700 (PDT)
Message-Id: <20130815.013501.1955235457701882095.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net/usb/r8152: enable interrupt
 transfer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376484880-741-3-git-send-email-hayeswang@realtek.com>
References: <1376378913-879-1-git-send-email-hayeswang@realtek.com>
	<1376484880-741-1-git-send-email-hayeswang@realtek.com>
	<1376484880-741-3-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 15 Aug 2013 01:35:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 14 Aug 2013 20:54:40 +0800

> Use the interrupt transfer to replace polling link status.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
