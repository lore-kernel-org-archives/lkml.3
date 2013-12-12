Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3LLRYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:24:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38449 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab3LLRYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:24:06 -0500
Date: Thu, 12 Dec 2013 12:24:03 -0500 (EST)
Message-Id: <20131212.122403.548901877993258405.davem@davemloft.net>
To: dvlasenk@redhat.com
Cc: hannes@stressinduktion.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, jpirko@redhat.com
Subject: Re: [patch net-next v2] ipv6: log autoconfiguration failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A99DD0.9030007@redhat.com>
References: <20131211192138.GB4675@order.stressinduktion.org>
	<20131211.155452.558417595732985707.davem@davemloft.net>
	<52A99DD0.9030007@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Dec 2013 09:24:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <dvlasenk@redhat.com>
Date: Thu, 12 Dec 2013 12:28:16 +0100

> Admins want to know why ipv6 autoconf didn't work, not so much
> how many times it didn't work. This requires a text message.

Again, they don't get this for ARP, or any other similar event.  Why
is ipv6 autoconf so damn special that it demands unique treatment?

I do not want each subsystem to decide their own custom way to
notify people that some interesting event happened.  That's the
worst possible user experience.
