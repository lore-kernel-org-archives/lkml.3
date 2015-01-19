Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbbASVSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:18:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34967 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbASVSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:18:33 -0500
Date: Mon, 19 Jan 2015 16:18:30 -0500 (EST)
Message-Id: <20150119.161830.1461440314206691151.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net 0/2] r8152: couldn't read OCP_SRAM_DATA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-126-Taiwan-albertk@realtek.com>
References: <1394712342-15778-126-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Jan 2015 13:18:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 19 Jan 2015 17:02:44 +0800

> Read OCP_SRAM_DATA would read additional bytes and may let
> the hw abnormal.

Series applied, thanks.
