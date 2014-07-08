Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaGHSax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:30:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53250 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbaGHSaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:30:52 -0400
Date: Tue, 08 Jul 2014 11:30:51 -0700 (PDT)
Message-Id: <20140708.113051.27675403933376517.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] ipconfig: add static to local variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404332540-5249-1-git-send-email-fabf@skynet.be>
References: <1404332540-5249-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 11:30:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  2 Jul 2014 22:22:20 +0200

> ic_dev_xid is only used in ipconfig.c
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied to net-next, thanks.
