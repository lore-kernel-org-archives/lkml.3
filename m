Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab3LLBUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:20:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60945 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3LLBUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:20:14 -0500
Date: Wed, 11 Dec 2013 20:20:12 -0500 (EST)
Message-Id: <20131211.202012.451563413045710135.davem@davemloft.net>
To: phdm@macqel.be
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frank.li@freescale.net
Subject: Re: [PATCH] net:fec: remove duplicate lines in comment about
 errata ERR006358
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386802252-5817-1-git-send-email-phdm@macqel.be>
References: <1386802252-5817-1-git-send-email-phdm@macqel.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 17:20:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: phdm@macqel.be
Date: Wed, 11 Dec 2013 23:50:52 +0100

> From: Philippe De Muyter <phdm@macqel.be>
> 
> commit 031916568a1aa2ef1809f86d26f0bcfa215ff5c0 worked around
> errata ERR006358, but comment contains duplicated lines, impairing
> the readability.  Remove them.
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>

Applied, thanks.
