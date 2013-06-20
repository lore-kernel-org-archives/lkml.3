Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab3FTEWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:22:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48633 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3FTEWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:22:43 -0400
Date: Wed, 19 Jun 2013 21:22:42 -0700 (PDT)
Message-Id: <20130619.212242.503302312923618047.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: aydin.arik@alliedtelesis.co.nz, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [PATCH v2] tcp: Fixed MD5 key lookups when
 adding/removing MD5.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371214687.3252.130.camel@edumazet-glaptop>
References: <1371209403-28275-1-git-send-email-aydin.arik@alliedtelesis.co.nz>
	<1371214687.3252.130.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 14 Jun 2013 05:58:07 -0700

> On Fri, 2013-06-14 at 23:30 +1200, Aydin Arik wrote:
>> MD5 key lookups on a given TCP socket were being performed
>> incorrectly. This fix alters parameter inputs to the MD5
>> lookup function tcp_md5_do_lookup, which is called by functions
>> tcp_md5_do_add and tcp_md5_do_del. Specifically, the change now
>> inputs the correct address and address family required to make
>> a proper lookup.
>> 
>> Commit a915da9b69273815527ccb3789421cb7027b545b ("tcp: md5: rcu conversion")
>> is the source of the regression.
>> 
>> Signed-off-by: Aydin Arik <aydin.arik@alliedtelesis.co.nz>

Applied, thanks.
