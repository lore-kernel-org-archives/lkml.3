Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbbALVLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:11:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53868 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbALVLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:11:04 -0500
Date: Mon, 12 Jan 2015 16:11:01 -0500 (EST)
Message-Id: <20150112.161101.337036741119753652.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2 RESEND] r8152: adjust r8152_submit_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-114-Taiwan-albertk@realtek.com>
References: <1394712342-15778-114-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 13:11:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 9 Jan 2015 10:26:34 +0800

> v2:
> Replace the patch #1 with "call rtl_start_rx after netif_carrier_on".
> 
> For patch #2, replace checking tp->speed with netif_carrier_ok.
> 
> v1:
> Avoid r8152_submit_rx() from submitting rx during unexpected
> moment. This could reduce the time of stopping rx.
> 
> For patch #1, the tp->speed should be updated early. Then,
> the patch #2 could use it to check the current linking status.

Series applied, thanks.
