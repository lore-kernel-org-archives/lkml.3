Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaJATrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:47:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35979 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaJATrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:47:31 -0400
Date: Wed, 01 Oct 2014 15:47:27 -0400 (EDT)
Message-Id: <20141001.154727.1004852358839073727.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] cipso: add __init to cipso_v4_cache_init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412184603-17294-1-git-send-email-fabf@skynet.be>
References: <1412184603-17294-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 12:47:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  1 Oct 2014 19:30:03 +0200

> cipso_v4_cache_init is only called by __init cipso_v4_init
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
