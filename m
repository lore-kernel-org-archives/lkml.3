Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab3LLSYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:24:48 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3LLSYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:24:44 -0500
Date: Thu, 12 Dec 2013 13:24:41 -0500 (EST)
Message-Id: <20131212.132441.1907656115241279246.davem@davemloft.net>
To: vyasevich@gmail.com
Cc: dvlasenk@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, jpirko@redhat.com
Subject: Re: [patch net-next v2] ipv6: log autoconfiguration failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A9F93A.5040104@gmail.com>
References: <52A99B56.1070503@redhat.com>
	<20131212.122241.2022824170198915190.davem@davemloft.net>
	<52A9F93A.5040104@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Dec 2013 10:24:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 12 Dec 2013 12:58:18 -0500

> On 12/12/2013 12:22 PM, David Miller wrote:
>> Give it statistics just like we have for every other kind of similar
>> event.
> 
> The fact that link-local address could not be generated for a specific
> device type does not lend itself well to counting.  There is no way
> from to tell from the counter which device does not support IPv6 autoconfig.

If the statistic is per-device, which I recommended it be implemented as,
you indeed can.

And I do not buy the argument that this is "useless" because the admin
is just going to kill the interface and create a new one.  When you
notice there is a problem, you look at the statistics before doing
that!
