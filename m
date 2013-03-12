Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab3CLPlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:41:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54182 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab3CLPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:41:22 -0400
Date: Tue, 12 Mar 2013 11:41:33 -0400 (EDT)
Message-Id: <20130312.114133.1990603651444409740.davem@davemloft.net>
To: zhangyanfei@cn.fujitsu.com
Cc: isdn@linux-pingi.de, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/18] driver: isdn: capi: remove cast for kmalloc
 return value
From: David Miller <davem@davemloft.net>
In-Reply-To: <513EB98B.9010400@cn.fujitsu.com>
References: <513EB23D.7020303@cn.fujitsu.com>
	<513EB98B.9010400@cn.fujitsu.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 12 Mar 2013 08:41:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:13:47 +0800

> remove cast for kmalloc return value.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Applied.
