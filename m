Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3HOIez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:34:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37825 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3HOIew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 04:34:52 -0400
Date: Thu, 15 Aug 2013 01:34:51 -0700 (PDT)
Message-Id: <20130815.013451.1035905405652002272.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] net/usb/r8152: support aggregation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376484880-741-1-git-send-email-hayeswang@realtek.com>
References: <1376378913-879-1-git-send-email-hayeswang@realtek.com>
	<1376484880-741-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 15 Aug 2013 01:34:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 14 Aug 2013 20:54:38 +0800

> Enable the tx/rx aggregation which could contain one or more packets
> for each bulk in/out. This could reduce the loading of the host
> controller by sending less bulk transfer.
> 
> The rx packets in the bulk in buffer should be 8-byte aligned, and
> the tx packets in the bulk out buffer should be 4-byte aligned.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
