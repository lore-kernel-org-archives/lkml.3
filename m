Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaJHUJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:09:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57306 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaJHUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:09:20 -0400
Date: Wed, 08 Oct 2014 16:09:18 -0400 (EDT)
Message-Id: <20141008.160918.1583864613017567450.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, paul@paul-moore.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] netlabel: directly return
 netlbl_unlabel_genl_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412793421-9914-1-git-send-email-fabf@skynet.be>
References: <1412793421-9914-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Oct 2014 13:09:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  8 Oct 2014 20:37:01 +0200

> No need to store netlbl_unlabel_genl_init result and test it before returning.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
