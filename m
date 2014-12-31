Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaLaTPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:15:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45217 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaLaTPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:15:39 -0500
Date: Wed, 31 Dec 2014 14:15:37 -0500 (EST)
Message-Id: <20141231.141537.1885739121180441904.davem@davemloft.net>
To: agartrell@fb.com
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next] tun: return proper error code from tun_do_read
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419578569-13132-1-git-send-email-agartrell@fb.com>
References: <1419578569-13132-1-git-send-email-agartrell@fb.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Dec 2014 11:15:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Gartrell <agartrell@fb.com>
Date: Thu, 25 Dec 2014 23:22:49 -0800

> Instead of -1 with EAGAIN, read on a O_NONBLOCK tun fd will return 0.  This
> fixes this by properly returning the error code from __skb_recv_datagram.
> 
> Signed-off-by: Alex Gartrell <agartrell@fb.com>

Applied.
