Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaJ0Crz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:47:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44077 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaJ0Crx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:47:53 -0400
Date: Sun, 26 Oct 2014 22:47:50 -0400 (EDT)
Message-Id: <20141026.224750.69834261666003874.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: klamm@yandex-team.ru, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, peter.p.waskiewicz.jr@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        tushar.n.dave@intel.com, sassmann@kpanic.de,
        gregkh@linuxfoundation.org, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATHC] net: napi_reuse_skb() should check pfmemalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414071030.2094.46.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1413992737.9031.1.camel@edumazet-glaptop2.roam.corp.google.com>
	<1811414063272@webcorp02e.yandex-team.ru>
	<1414071030.2094.46.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Oct 2014 19:47:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 23 Oct 2014 06:30:30 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> Do not reuse skb if it was pfmemalloc tainted, otherwise
> future frame might be dropped anyway.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
