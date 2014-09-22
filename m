Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaIVSyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:54:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52925 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaIVSys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:54:48 -0400
Date: Mon, 22 Sep 2014 14:54:46 -0400 (EDT)
Message-Id: <20140922.145446.2112922203236872469.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: disable ALDPS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-44-Taiwan-albertk@realtek.com>
References: <1394712342-15778-44-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Sep 2014 11:54:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 19 Sep 2014 15:17:18 +0800

> If the hw is in ALDPS mode, the hw may have no response for accessing
> the most registers. Therefore, the ALDPS should be disabled before
> accessing the hw in rtl_ops.init(), rtl_ops.disable(), rtl_ops.up(),
> and rtl_ops.down(). Regardless of rtl_ops.enable(), because the hw
> wouldn't enter ALDPS mode when linking on. The hw would enter the
> ALDPS mode after several seconds when link down occurs and the ALDPS
> is enabled.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
