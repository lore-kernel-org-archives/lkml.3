Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3JRUXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:23:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58140 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3JRUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:23:31 -0400
Date: Fri, 18 Oct 2013 16:23:29 -0400 (EDT)
Message-Id: <20131018.162329.1919694379284940208.davem@davemloft.net>
To: stephen@networkplumber.org
Cc: rdunlap@infradead.org, lve@guap.ru, thierry.reding@gmail.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com
Subject: Re: [PATCH net-next] em_ipset: use dev_net() accessor
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131016172934.7913a297@nehalam.linuxnetplumber.net>
References: <20131016153949.5f2257b4@nehalam.linuxnetplumber.net>
	<525F2D7D.7010708@infradead.org>
	<20131016172934.7913a297@nehalam.linuxnetplumber.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 18 Oct 2013 13:23:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Wed, 16 Oct 2013 17:29:34 -0700

> Randy found that if network namespace not enabled then
> nd_net does not exist and would cause compilation failure.
> 
> This is handled correctly by using the dev_net() macro.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks everyone.
