Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab3LLTGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:06:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39080 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3LLTGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:06:12 -0500
Date: Thu, 12 Dec 2013 14:06:09 -0500 (EST)
Message-Id: <20131212.140609.955709321823979833.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: vyasevich@gmail.com, dvlasenk@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, jpirko@redhat.com
Subject: Re: [patch net-next v2] ipv6: log autoconfiguration failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131212190042.GH4675@order.stressinduktion.org>
References: <52A9F93A.5040104@gmail.com>
	<20131212.132441.1907656115241279246.davem@davemloft.net>
	<20131212190042.GH4675@order.stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Dec 2013 11:06:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Thu, 12 Dec 2013 20:00:42 +0100

> IMHO both ways are fine with a slight opionion to counters being
> overkill. ;)

Counters don't scroll out of the log last time I checked too :)
