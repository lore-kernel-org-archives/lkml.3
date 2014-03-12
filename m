Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaCLEJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:09:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33442 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaCLEJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:09:24 -0400
Date: Wed, 12 Mar 2014 00:09:22 -0400 (EDT)
Message-Id: <20140312.000922.2022001588288263753.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: support dumping the hw counters
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394526259-5513-1-git-send-email-hayeswang@realtek.com>
References: <1394526259-5513-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Mar 2014 21:09:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 11 Mar 2014 16:24:19 +0800

> Add dumping the tally counter by ethtool.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
