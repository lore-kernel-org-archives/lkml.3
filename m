Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaDATWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:22:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54086 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaDATWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:22:07 -0400
Date: Tue, 01 Apr 2014 15:22:03 -0400 (EDT)
Message-Id: <20140401.152203.847120817141929645.davem@davemloft.net>
To: rdunlap@infradead.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 1 (netfilter)
From: David Miller <davem@davemloft.net>
In-Reply-To: <533B06A7.5010900@infradead.org>
References: <20140401183907.a5127cadbe7116261096beaa@canb.auug.org.au>
	<533B06A7.5010900@infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Apr 2014 12:22:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Tue, 01 Apr 2014 11:34:15 -0700

> on x86_64:
> 
> net/netfilter/xt_connlimit.c: In function 'connlimit_mt_check':
> net/netfilter/xt_connlimit.c:380:18: warning: division by zero [-Wdiv-by-zero]
> 
> Maybe just use CONNLIMIT_LOCK_SLOTS instead of ARRAY_SIZE(...).

I'd rather see that ARRAY_SIZE() be adjusted to work cleanly for zero
sized array elements.
