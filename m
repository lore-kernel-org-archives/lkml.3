Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbaJaR4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:56:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42050 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbaJaR4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:56:09 -0400
Date: Fri, 31 Oct 2014 13:56:06 -0400 (EDT)
Message-Id: <20141031.135606.1420214285713635362.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: stop submitting intr for -EPROTO
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-74-Taiwan-albertk@realtek.com>
References: <1394712342-15778-74-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Oct 2014 10:56:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 31 Oct 2014 13:35:57 +0800

> For Renesas USB 3.0 host controller, when unplugging the usb hub which
> has the RTL8153 plugged, the driver would get -EPROTO for interrupt
> transfer. There is high probability to get the information of "HC died;
> cleaning up", if the driver continues to submit the interrupt transfer
> before the disconnect() is called.
 ...
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
