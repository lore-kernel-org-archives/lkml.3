Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaBSGFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:05:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39027 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaBSGFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:05:11 -0500
Date: Wed, 19 Feb 2014 01:05:09 -0500 (EST)
Message-Id: <20140219.010509.484470671732800480.davem@davemloft.net>
To: daeseok.youn@gmail.com
Cc: tj@kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: libahci: replace obselete simple_strtoul() with
 kstrtouint()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1983660.RVkLooTtjT@daeseok-laptop.cloud.net>
References: <1983660.RVkLooTtjT@daeseok-laptop.cloud.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2014 22:05:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Wed, 19 Feb 2014 14:09:49 +0900

> From 18bd7236f36a248a0871f810cec3c1e98f098a91 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Wed, 19 Feb 2014 13:44:24 +0900
> Subject: [PATCH] atm: libahci: replace obselete simple_strtoul() with
>  kstrtouint()
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Please fix your Subject line, you meant "ata: " not "atm: "
