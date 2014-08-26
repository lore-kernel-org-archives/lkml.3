Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbaHZJSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:18:33 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:38987 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933975AbaHZJSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:18:32 -0400
Message-ID: <1409044603.2489.7.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: scan: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Date: Tue, 26 Aug 2014 11:16:43 +0200
In-Reply-To: <20140822131449.GA19959@ada> (sfid-20140822_151532_626084_CD0D5F37)
References: <20140822131449.GA19959@ada>
	 (sfid-20140822_151532_626084_CD0D5F37)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 16:14 +0300, Andreea-Cristina Bernat wrote:
> The use of "rcu_assign_pointer()" is NULLing out the pointer.
> According to RCU_INIT_POINTER()'s block comment:
> "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> it is better to use it instead of rcu_assign_pointer() because it has a
> smaller overhead.

Applied, thanks.

johannes

