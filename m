Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaLJSsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:48:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46623 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbaLJSsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:48:08 -0500
Date: Wed, 10 Dec 2014 13:48:04 -0500 (EST)
Message-Id: <20141210.134804.1383875260695429574.davem@davemloft.net>
To: guz.fnst@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH v2] net: introduce helper macro for_each_cmsghdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <5487DBD9.1010908@cn.fujitsu.com>
References: <5487DBD9.1010908@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 10:48:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Wed, 10 Dec 2014 13:36:25 +0800

> Introduce helper macro for_each_cmsghdr as a wrapper of the enumerating
> cmsghdr from msghdr, just cleanup. 
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Applied, thanks.
