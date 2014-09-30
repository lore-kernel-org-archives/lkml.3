Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaI3VIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:08:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49973 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaI3VIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:08:40 -0400
Date: Tue, 30 Sep 2014 17:08:38 -0400 (EDT)
Message-Id: <20140930.170838.555234528916255681.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] ieee802154: add __init to
 lowpan_frags_sysctl_register
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412109249-7432-1-git-send-email-fabf@skynet.be>
References: <1412109249-7432-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 14:08:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue, 30 Sep 2014 22:34:08 +0200

> lowpan_frags_sysctl_register is only called by __init lowpan_net_frag_init
> (part of the lowpan module).
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
