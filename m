Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab3G3XTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:19:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43297 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab3G3XTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:19:07 -0400
Date: Tue, 30 Jul 2013 16:19:06 -0700 (PDT)
Message-Id: <20130730.161906.1898764862564749288.davem@davemloft.net>
To: sam8641@gmail.com
Cc: mlindner@marvell.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: detect and prevent kernel panic from a possible
 faulty hardware
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374957354-10142-1-git-send-email-sam8641@gmail.com>
References: <1374957354-10142-1-git-send-email-sam8641@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 16:19:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Williams <sam8641@gmail.com>
Date: Sat, 27 Jul 2013 15:35:54 -0500

> A possible faulty hardware might interrupt with a status of 0xffffffff which
> may kernel panic if sky2 driver tries to handle it. Detecting this problem
> may avoid kernel panic.
> 
> Signed-off-by: Samuel Williams <sam8641@gmail.com>

Sure, but then the device is basically just going to stop.

I think this change needs to be more comprehensive, for example it
needs to fully reset the device and try to get it operational again.
