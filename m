Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3JRUcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:32:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58207 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3JRUcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:32:03 -0400
Date: Fri, 18 Oct 2013 16:32:01 -0400 (EDT)
Message-Id: <20131018.163201.1946075086732460816.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/9] Introduce support to lazy initialize
 mostly static keys
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381987923-1524-1-git-send-email-hannes@stressinduktion.org>
References: <1381987923-1524-1-git-send-email-hannes@stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 18 Oct 2013 13:32:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Thu, 17 Oct 2013 07:31:54 +0200

> This series implements support for delaying the initialization of secret
> keys, e.g. used for hashing, for as long as possible. This functionality
> is implemented by a new macro, net_get_random_bytes.
> 
> I already used it to protect the socket hashes, the syncookie secret
> (most important) and the tcp_fastopen secrets.

I generally have no problem with this series and like how it improves the
secret being input on the ipv6 side.

Please address the commit message feedback and respin this series.

Thanks.
