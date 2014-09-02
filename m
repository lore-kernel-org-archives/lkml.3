Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaIBDmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:42:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46922 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaIBDmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:42:33 -0400
Date: Mon, 01 Sep 2014 20:42:32 -0700 (PDT)
Message-Id: <20140901.204232.1824043953151511854.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: rename rx_buf_sz
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-25-Taiwan-albertk@realtek.com>
References: <1394712342-15778-25-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Sep 2014 20:42:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 2 Sep 2014 10:27:52 +0800

> The variable "rx_buf_sz" is used by both tx and rx buffers. Replace
> it with "agg_buf_sz".
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
