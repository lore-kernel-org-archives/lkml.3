Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaJHT72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:59:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57186 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbaJHT70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:59:26 -0400
Date: Wed, 08 Oct 2014 15:59:24 -0400 (EDT)
Message-Id: <20141008.155924.55313801969969450.davem@davemloft.net>
To: hau@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next] r8169:add support for RTL8168EP
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412665841-7338-1-git-send-email-hau@realtek.com>
References: <1412665841-7338-1-git-send-email-hau@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Oct 2014 12:59:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chun-Hao Lin <hau@realtek.com>
Date: Tue, 7 Oct 2014 15:10:41 +0800

> RTL8168EP is Realtek PCIe Gigabit Ethernet controller with DASH support.
> It is a successor chip of RTL8168DP.
> 
> For RTL8168EP, the read/write ocp register is via eri channel type 2, so I
> move ocp_xxx() related functions under rtl_eri_xxx. And use r8168dp_ocp_xxx()
> for RTL8168DP ocp read/write, r8168ep_ocp_xxx() for RTL8168EP ocp read/write.
> 
> The way of checking dash enable is different with RTL8168DP. I use
> r8168dp_check_dash()for RTL8168DP and r8168ep_check_dash() for RTL8168EP,
> to check if dash is enabled.
> 
> The driver_start() and driver_stop() of RTL8168EP is also different with
> RTL8168DP. I use rtl8168dp_driver_xxx() for RTL8168DP and
> rtl8168ep_driver_xxx for RTL8168EP.
> 
> Right now, RTL8168EP phy mcu did not need firmware code patch, so I did not
> add firmware code for it.
> so I did not add firmware code for it.
> 
> Signed-off-by: Chun-Hao Lin <hau@realtek.com>

I'll apply this, but if Francois has more feedback please work on it
with follow-on changes.

Thank you.
