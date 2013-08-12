Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3HLEdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 00:33:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47547 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3HLEdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 00:33:35 -0400
Date: Sun, 11 Aug 2013 21:38:46 -0700 (PDT)
Message-Id: <20130811.213846.2022624715665927428.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, florian@openwrt.org,
        joe@perches.com, mark.rutland@arm.com
Subject: Re: [PATCH v5] net: Add MOXA ART SoCs ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375961694-5375-1-git-send-email-jonas.jensen@gmail.com>
References: <1375349968-16059-1-git-send-email-jonas.jensen@gmail.com>
	<1375961694-5375-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 11 Aug 2013 21:33:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Thu,  8 Aug 2013 13:34:54 +0200

> The MOXA UC-711X hardware(s) has an ethernet controller that seem
> to be developed internally. The IC used is "RTL8201CP".
> 
> Since there is no public documentation, this driver is mostly the
> one published by MOXA that has been heavily cleaned up / ported
> from linux 2.6.9.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied to net-next, thanks.
