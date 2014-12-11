Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbaLKDmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:42:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50017 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557AbaLKDmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:42:35 -0500
Date: Wed, 10 Dec 2014 22:42:30 -0500 (EST)
Message-Id: <20141210.224230.1611636286785782770.davem@davemloft.net>
To: guz.fnst@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH v3] net: introduce helper macro for_each_cmsghdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <54890DDC.3040402@cn.fujitsu.com>
References: <54890DDC.3040402@cn.fujitsu.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 19:42:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 11:22:04 +0800

> Introduce helper macro for_each_cmsghdr as a wrapper of the enumerating
> cmsghdr from msghdr, just cleanup.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
> v3:
>  -drop the changes about user-land programs as David suggested.
> v2:
>  -use the lower-case macro name as Joe suggested.

Applied, thanks.
