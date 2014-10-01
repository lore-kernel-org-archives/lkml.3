Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaJATlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:41:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35888 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJATls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:41:48 -0400
Date: Wed, 01 Oct 2014 15:41:45 -0400 (EDT)
Message-Id: <20141001.154145.954072039606699747.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] tcp: add __init to tcp_init_mem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412180870-7599-1-git-send-email-fabf@skynet.be>
References: <1412180870-7599-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 12:41:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  1 Oct 2014 18:27:50 +0200

> tcp_init_mem is only called by __init tcp_init.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thank you.
