Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3KOWkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:40:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60271 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3KOWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:39:52 -0500
Date: Fri, 15 Nov 2013 17:39:48 -0500 (EST)
Message-Id: <20131115.173948.1712849813995511721.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v3 1/4] r8152: fix tx/rx memory overflow
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384502279-9959-2-git-send-email-hayeswang@realtek.com>
References: <1384502279-9959-1-git-send-email-hayeswang@realtek.com>
	<1384502279-9959-2-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Nov 2013 14:39:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 15 Nov 2013 15:57:56 +0800

> +			unsigned pkt_len;

Please fully specify the type as "unsigned int".  Please check for this
problem in the rest of your patches too.

Thanks.
