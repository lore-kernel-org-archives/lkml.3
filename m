Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3LLRWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:22:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38426 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3LLRWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:22:44 -0500
Date: Thu, 12 Dec 2013 12:22:41 -0500 (EST)
Message-Id: <20131212.122241.2022824170198915190.davem@davemloft.net>
To: dvlasenk@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        jpirko@redhat.com
Subject: Re: [patch net-next v2] ipv6: log autoconfiguration failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A99B56.1070503@redhat.com>
References: <1386762314-5149-1-git-send-email-dvlasenk@redhat.com>
	<20131211192138.GB4675@order.stressinduktion.org>
	<52A99B56.1070503@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Dec 2013 09:22:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <dvlasenk@redhat.com>
Date: Thu, 12 Dec 2013 12:17:42 +0100

> I can easily imagine their frustration. Kernel _knows_ why
> it didn't work, and it's not expected to normally pappen,
> why didn't it tell anything about it?

Packets are dropped silently, ARP fails and entries go stale silently,
none of this is logged with kernel messages, why is ipv6 autoconf so
unique and important to justify different behavior?

Give it statistics just like we have for every other kind of similar
event.
