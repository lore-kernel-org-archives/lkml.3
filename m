Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbbANUG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:06:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44859 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbbANUGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:06:55 -0500
Date: Wed, 14 Jan 2015 15:06:49 -0500 (EST)
Message-Id: <20150114.150649.475667638817956451.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: replace tasklet with NAPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-117-Taiwan-albertk@realtek.com>
References: <1394712342-15778-117-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Jan 2015 12:06:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 12 Jan 2015 12:06:23 +0800

> Replace tasklet with NAPI.
> 
> Add rx_queue to queue the remaining rx packets if the number of the
> rx packets is more than the request from poll().
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
