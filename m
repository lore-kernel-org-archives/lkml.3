Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3IQXHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:07:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43417 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3IQXHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:07:17 -0400
Date: Tue, 17 Sep 2013 19:07:15 -0400 (EDT)
Message-Id: <20130917.190715.1868248025150913908.davem@davemloft.net>
To: avi.kp.137@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers: net: phy: cicada.c: clears warning Use
 #include <linux/io.h> instead of <asm/io.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379347781-7145-1-git-send-email-avi.kp.137@gmail.com>
References: <1379347781-7145-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 17 Sep 2013 16:07:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avinash Kumar <avi.kp.137@gmail.com>
Date: Mon, 16 Sep 2013 21:39:41 +0530

> clears following warnings :
> WARNING: Use include <linux/io.h> instead of <asm/io.h>
> WARNING: Use include <linux/uaccess.h> instead of <asm/uaccess.h>
> 
> Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>

Applied, thanks.
