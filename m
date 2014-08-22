Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaHVEf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:35:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46165 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaHVEfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:35:25 -0400
Date: Thu, 21 Aug 2014 21:35:23 -0700 (PDT)
Message-Id: <20140821.213523.1210166206674176289.davem@davemloft.net>
To: zyjzyj2000@gmail.com
Cc: dborkman@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, tuexen@fh-muenster.de,
        khandelwal.deepak.1987@gmail.com, Yue.Tao@windriver.com,
        alexandre.dietsch@windriver.com, Yanjun.Zhu@windriver.com
Subject: Re: [PATCH 1/1] sctp: not send SCTP_PEER_ADDR_CHANGE notifications
 with failed probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408527103-22772-2-git-send-email-Yanjun.Zhu@windriver.com>
References: <1408527103-22772-1-git-send-email-Yanjun.Zhu@windriver.com>
	<1408527103-22772-2-git-send-email-Yanjun.Zhu@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Aug 2014 21:35:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhu Yanjun <zyjzyj2000@gmail.com>
Date: Wed, 20 Aug 2014 17:31:43 +0800

> Since the transport has always been in state SCTP_UNCONFIRMED, it
> therefore wasn't active before and hasn't been used before, and it
> always has been, so it is unnecessary to bug the user with a 
> notification.
> 
> Reported-by: Deepak Khandelwal <khandelwal.deepak.1987@gmail.com>  
> Suggested-by: Vlad Yasevich <vyasevich@gmail.com> 
> Suggested-by: Michael Tuexen <tuexen@fh-muenster.de>
> Suggested-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>

Applied, thanks.
