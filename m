Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbaLKBrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:47:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49465 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaLKBrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:47:06 -0500
Date: Wed, 10 Dec 2014 20:47:03 -0500 (EST)
Message-Id: <20141210.204703.1525194278635097457.davem@davemloft.net>
To: guz.fnst@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH v2] net: introduce helper macro for_each_cmsghdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <5488EDF7.7070001@cn.fujitsu.com>
References: <20141210.134804.1383875260695429574.davem@davemloft.net>
	<20141210.144430.1749715282635917425.davem@davemloft.net>
	<5488EDF7.7070001@cn.fujitsu.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 17:47:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 09:05:59 +0800

> IMO, the user-land programs need to be build with the matched
> headers separately.

You absolutely cannot provide this new interface to userland and
expect programs to be able to just use it, it's non-standard and does
not exist in older headers.

I do not want this new interface available to userland programs.
They can just open-code the list traversal just like every program
in history has had to do since BSD UNIX.
