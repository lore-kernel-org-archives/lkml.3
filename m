Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3APVhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:37:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39511 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab3APVhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:37:32 -0500
Date: Wed, 16 Jan 2013 16:37:29 -0500 (EST)
Message-Id: <20130116.163729.1934084260354327196.davem@davemloft.net>
To: fabio.baltieri@linaro.org
Cc: netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        kaber@trash.net
Subject: Re: [PATCH net-next] ipv6: fix ipv6_prefix_equal64_half mask
 conversion
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358371817-15378-1-git-send-email-fabio.baltieri@linaro.org>
References: <1358371817-15378-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Baltieri <fabio.baltieri@linaro.org>
Date: Wed, 16 Jan 2013 22:30:17 +0100

> Fix the 64bit optimized version of ipv6_prefix_equal to convert the
> bitmask to network byte order only after the bit-shift.
> 
> The bug was introduced in:
> 
> 3867517 ipv6: 64bit version of ipv6_prefix_equal().
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Applied, thanks.
