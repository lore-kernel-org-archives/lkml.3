Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3LKUBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:01:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59107 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3LKUBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:01:40 -0500
Date: Wed, 11 Dec 2013 15:01:37 -0500 (EST)
Message-Id: <20131211.150137.368953964178408437.davem@davemloft.net>
To: grothoff@in.tum.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, knock@gnunet.org,
        jacob@appelbaum.net
Subject: Re: [PATCH] TCP: add option for silent port knocking with
 integrity protection
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A75EF8.3010308@in.tum.de>
References: <52A75EF8.3010308@in.tum.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 12:01:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Grothoff <grothoff@in.tum.de>
Date: Tue, 10 Dec 2013 19:35:36 +0100

> Only NAT implementations that change the SQN are not supported
> (those should be rare, but we have no hard data on this).

Even Linux's netfilter can and does do this, it is absolutely necessary
for tracking SIP and FTP protocols, and it's also used in our virtual
server load balancing modules.
