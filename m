Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3CRRH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:07:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59465 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3CRRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:07:27 -0400
Date: Mon, 18 Mar 2013 13:07:23 -0400 (EDT)
Message-Id: <20130318.130723.5448740810527224.davem@davemloft.net>
To: slash@ac.auone-net.jp
Cc: netdev@vger.kernel.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] macvlan: Remove an unnecessary goto
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130318130339.4F76662C03B@msa106.auone-net.jp>
References: <20130318130339.4F76662C03B@msa106.auone-net.jp>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Mar 2013 10:07:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kusanagi Kouichi <slash@ac.auone-net.jp>
Date: Mon, 18 Mar 2013 22:03:39 +0900

> Use else instead.
> 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>

The code is not in any way more readable with your changes.

I'm not applying this.
