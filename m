Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3LMW5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:57:14 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46892 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3LMW5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:57:13 -0500
Date: Fri, 13 Dec 2013 17:57:09 -0500 (EST)
Message-Id: <20131213.175709.414078764436451428.davem@davemloft.net>
To: dvlasenk@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        jpirko@redhat.com
Subject: Re: [patch net-next v3] ipv6: log autoconfiguration failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386949547-23457-1-git-send-email-dvlasenk@redhat.com>
References: <1386949547-23457-1-git-send-email-dvlasenk@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 13 Dec 2013 14:57:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <dvlasenk@redhat.com>
Date: Fri, 13 Dec 2013 16:45:47 +0100

> If ipv6 auto-configuration does not work, currently it's hard
> to track what's going on. This change adds log messages
> (at debug level) on every code path where ipv6 autoconf fails.
> 
> v3: changed pr_debug's to pr_warn's.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

I already made it clear I want to see statistics added instead of log
messages for this.

I'm not applying this patch, sorry.
