Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbaJ3Tw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:52:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58633 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761020AbaJ3Twy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:52:54 -0400
Date: Thu, 30 Oct 2014 15:52:52 -0400 (EDT)
Message-Id: <20141030.155252.46450705810333675.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipv6: remove inline on static in c file
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414579097-11659-1-git-send-email-fabf@skynet.be>
References: <1414579097-11659-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 12:52:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed, 29 Oct 2014 11:38:17 +0100

> remove __inline__ / inline and let compiler decide what to do
> with static functions
> 
> Inspired-by: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
