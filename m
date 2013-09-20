Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3ITSmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:42:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39325 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3ITSmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:42:36 -0400
Date: Fri, 20 Sep 2013 14:42:34 -0400 (EDT)
Message-Id: <20130920.144234.1253837765082596306.davem@davemloft.net>
To: avi.kp.137@gmail.com
Cc: akong@redhat.com, stefanha@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] net: ethernet: eth.c: removed checkpatch warnings
 and errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <523b2124.645d440a.1c55.0f75@mx.google.com>
References: <523b2124.645d440a.1c55.0f75@mx.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 20 Sep 2013 11:42:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: avi.kp.137@gmail.com
Date: Thu, 19 Sep 2013 21:36:50 +0530

> From: Avinash Kumar <avi.kp.137@gmail.com>
> 
> removed these checkpatch.pl warnings:
> net/ethernet/eth.c:61: WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> net/ethernet/eth.c:136: WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> net/ethernet/eth.c:181: ERROR: space prohibited before that close parenthesis ')'
> 
> Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>

Applied.
