Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaKXVss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:48:48 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54078 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaKXVsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:48:46 -0500
Date: Mon, 24 Nov 2014 16:48:42 -0500 (EST)
Message-Id: <20141124.164842.1289257824447246212.davem@davemloft.net>
To: a17711@motorola.com
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        stable@vger.kernel.org, gbjc64@motorola.com
Subject: Re: [PATCH] net/ping: handle protocol mismatching scenario
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416858248-29258-1-git-send-email-a17711@motorola.com>
References: <1416858248-29258-1-git-send-email-a17711@motorola.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 13:48:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jane Zhou <a17711@motorola.com>
Date: Mon, 24 Nov 2014 11:44:08 -0800

> ping_lookup() may return a wrong sock if sk_buff's and sock's protocols
> dont' match. For example, sk_buff's protocol is ETH_P_IPV6, but sock's
> sk_family is AF_INET, in that case, if sk->sk_bound_dev_if is zero, a wrong
> sock will be returned.
> the fix is to "continue" the searching, if no matching, return NULL.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: netdev@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Jane Zhou <a17711@motorola.com>
> Signed-off-by: Yiwei Zhao <gbjc64@motorola.com>

Applied, thank you.
