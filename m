Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab3FKIOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:14:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36825 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3FKIOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:14:30 -0400
Date: Tue, 11 Jun 2013 01:14:27 -0700 (PDT)
Message-Id: <20130611.011427.2250431661196003301.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        erdnetdev@gmail.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH v10 net-next 0/6] net: low latency Ethernet device
 polling
From: David Miller <davem@davemloft.net>
In-Reply-To: <51B6C87B.70101@linux.intel.com>
References: <51B68AA6.1050105@linux.intel.com>
	<20130610.212443.1096102996038709384.davem@davemloft.net>
	<51B6C87B.70101@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Tue, 11 Jun 2013 09:49:31 +0300

> I would like to hear opinions on what needs to be added to make this
> feature complete.
> 
> The list I have so far is:
> 1. add a socket option
> 2. support for poll/select
> 3. support for epoll

I actually would like to see the Kconfig option go away, that's
my only request.

> Also, would you accept a trailing whitespace cleanup patch for
> fs/select.c?

That's not really for my tree, sorry.
