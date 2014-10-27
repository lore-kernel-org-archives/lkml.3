Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaJ0UEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:04:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50543 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaJ0UEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:04:52 -0400
Date: Mon, 27 Oct 2014 16:04:49 -0400 (EDT)
Message-Id: <20141027.160449.423435641618403620.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, joe@perches.com, acme@ghostprotocols.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH V2 net-next] ipx: remove unnecessary casting on ntohl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414439709-5870-1-git-send-email-fabf@skynet.be>
References: <1414439709-5870-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 13:04:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 27 Oct 2014 20:55:08 +0100

> use %08X instead of %08lX and remove casting.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2: remove casting instead of long unsigned int -> unsigned long
> (suggested by Joe Perches)

Applied.
