Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3ETTkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:40:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36848 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3ETTke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:40:34 -0400
Date: Mon, 20 May 2013 12:40:33 -0700 (PDT)
Message-Id: <20130520.124033.768310591871485191.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: eliezer.tamir@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        donald.c.skidmore@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, andi@firstfloor.org, hpa@zytor.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH v3 net-next 1/4] net: implement support for low latency
 socket polling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369063764.3301.182.camel@edumazet-glaptop>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	<20130520101601.14133.874.stgit@ladj378.jer.intel.com>
	<1369063764.3301.182.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 12:40:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 20 May 2013 08:29:24 -0700

> Part of this information was in your 0/4 text, but it wont be included
> in the git tree.

Yes it will, in the merge commit I make when I merge this stuff in.
