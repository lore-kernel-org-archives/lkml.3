Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaH0KOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:14:37 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:44803 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbaH0KOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:14:35 -0400
Message-ID: <1409134463.2505.6.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: Replace rcu_dereference() with
 rcu_access_pointer()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Date: Wed, 27 Aug 2014 12:14:23 +0200
In-Reply-To: <20140817131801.GA24286@ada> (sfid-20140817_151809_334504_0D1A926E)
References: <20140817131801.GA24286@ada>
	 (sfid-20140817_151809_334504_0D1A926E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-17 at 16:18 +0300, Andreea-Cristina Bernat wrote:
> The "rcu_dereference()" calls are used directly in conditions.
> Since their return values are never dereferenced it is recommended to
> use "rcu_access_pointer()" instead of "rcu_dereference()".
> Therefore, this patch makes the replacements.

Applied, thanks.

johannes

