Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbbAFSap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:30:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52296 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbbAFSam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:30:42 -0500
Date: Tue, 06 Jan 2015 13:30:40 -0500 (EST)
Message-Id: <20150106.133040.1248555811773223317.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: support ndo_features_check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-113-Taiwan-albertk@realtek.com>
References: <1394712342-15778-113-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 10:30:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 6 Jan 2015 17:41:58 +0800

> Support ndo_features_check to avoid:
>  - the transport offset is more than the hw limitation when using hw checksum.
>  - the skb->len of a GSO packet is more than the limitation.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
