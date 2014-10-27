Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaJ0UZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:25:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50719 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaJ0UZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:25:56 -0400
Date: Mon, 27 Oct 2014 16:25:54 -0400 (EDT)
Message-Id: <20141027.162554.1582020588592240837.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH V2 net-next] ipx: remove __inline__ in c file on static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414440728-6144-1-git-send-email-fabf@skynet.be>
References: <1414440728-6144-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 13:25:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 27 Oct 2014 21:12:08 +0100

> Let compiler decide what to do with static void __ipxitf_put()
> 
> Suggested-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2: remove __inline__ instead of replacing it by standard inline
> (suggested by David S. Miller)

Applied, thanks Fabian.
