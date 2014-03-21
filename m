Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaCUTcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:32:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35304 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaCUTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:32:40 -0400
Date: Fri, 21 Mar 2014 15:32:37 -0400 (EDT)
Message-Id: <20140321.153237.2236797908349183626.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
From: David Miller <davem@davemloft.net>
In-Reply-To: <84837c9e73f24bcd8f652a24f616ff1e@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20140321.144957.550032279989990583.davem@davemloft.net>
	<20140321.145501.2003616654661701935.davem@davemloft.net>
	<84837c9e73f24bcd8f652a24f616ff1e@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Mar 2014 12:32:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 21 Mar 2014 19:12:43 +0000

> Could it be merged into net-next tree?

You submitted a patch against net-next, that means you are implicitly
stating that all dependencies are in place in _that_ tree and that
you tested it in _that_ tree.

If the situation is otherwise you must explicitly state this in your
patch submission.
