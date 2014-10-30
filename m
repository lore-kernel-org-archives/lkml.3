Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbaJ3TxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:53:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58642 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761083AbaJ3TxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:53:01 -0400
Date: Thu, 30 Oct 2014 15:52:58 -0400 (EDT)
Message-Id: <20141030.155258.1266322934969114603.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipv6: remove assignment in if condition
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414583871-14196-1-git-send-email-fabf@skynet.be>
References: <1414583871-14196-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 12:53:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed, 29 Oct 2014 12:57:51 +0100

> Do assignment before if condition and test !skb like in rawv6_recvmsg()
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
