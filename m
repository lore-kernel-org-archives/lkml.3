Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaFBUkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:40:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36552 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaFBUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:40:39 -0400
Date: Mon, 02 Jun 2014 13:40:37 -0700 (PDT)
Message-Id: <20140602.134037.340629330868591957.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, kuznet@ms2.inr.ac.ru
Subject: Re: [PATCH v2] net: tunnels - enable module autoloading
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAG-2HqUEqz26YMTDHNVHUEtWDcaVrq3EKX-e8-9wnm4Y1XCUag@mail.gmail.com>
References: <1400188890-2038-1-git-send-email-teg@jklm.no>
	<20140521.154744.124910385161203311.davem@davemloft.net>
	<CAG-2HqUEqz26YMTDHNVHUEtWDcaVrq3EKX-e8-9wnm4Y1XCUag@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 13:40:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Mon, 2 Jun 2014 20:57:02 +0200

> Would this patch be suitable for stable? While it does not fix a
> regression, it appears to fix the intended behaviour of
> MODULE_ALIAS_RTNL_LINK?

It probably is suitable... I'll queue it up, thanks.
