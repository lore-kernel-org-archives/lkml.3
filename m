Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaKDV6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:58:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59727 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDV6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:58:42 -0500
Date: Tue, 04 Nov 2014 16:58:37 -0500 (EST)
Message-Id: <20141104.165837.2166936588915191109.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, joe@perches.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH V2 net-next] esp4: remove assignment in if condition
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415138076-7036-1-git-send-email-fabf@skynet.be>
References: <1415138076-7036-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Nov 2014 13:58:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue,  4 Nov 2014 22:54:36 +0100

> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2: remove blank line between set and test (suggested by Joe Perches).

Applied, thanks.
