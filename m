Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaLSDkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:40:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51765 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaLSDkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:40:18 -0500
Date: Thu, 18 Dec 2014 22:40:11 -0500 (EST)
Message-Id: <20141218.224011.175832100672931963.davem@davemloft.net>
To: dan@dcollins.co.nz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed TPACKET V3 to signal poll when block is closed
 rather than every packet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418949139-21299-1-git-send-email-dan@dcollins.co.nz>
References: <1418949139-21299-1-git-send-email-dan@dcollins.co.nz>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Dec 2014 19:40:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Collins <dan@dcollins.co.nz>
Date: Fri, 19 Dec 2014 13:32:19 +1300

> + *		Dan Collins : Fixed TPACKET_V3 to wake poll when block is closed
> + *					rather than for every packet.

Since we now use real version control with commit messages, this
comment at the top of the source file is not an appropriate
place to log your change.
