Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab3HTHJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:09:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36590 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3HTHJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:09:15 -0400
Date: Tue, 20 Aug 2013 00:09:14 -0700 (PDT)
Message-Id: <20130820.000914.921286776807872431.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] r8152: remove clearing the memory to zero
 for netdev priv
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376640578-4258-1-git-send-email-hayeswang@realtek.com>
References: <1376640578-4258-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 00:09:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Series applied, thanks.

Please, in the future, provide an initial "[PATCH 0/N] " posting which
gives a general overview to the series, and to which I can apply when
I have something to say about the series as a whole.

Thanks.
