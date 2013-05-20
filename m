Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3ETJQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:16:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56005 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3ETJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:16:17 -0400
Date: Mon, 20 May 2013 02:16:14 -0700 (PDT)
Message-Id: <20130520.021614.1748558994745374855.davem@davemloft.net>
To: joe@perches.com
Cc: eliezer.tamir@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        donanld.c.skidmore@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, andi@firstfloor.org, hpa@zytor.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH v2 net-next 1/4] net: implement support for low latency
 socket polling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369038587.2143.12.camel@joe-AO722>
References: <20130519102533.12527.12991.stgit@ladj378.jer.intel.com>
	<20130520.005447.972811583292360876.davem@davemloft.net>
	<1369038587.2143.12.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 02:16:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 20 May 2013 01:29:47 -0700

> On Mon, 2013-05-20 at 00:54 -0700, David Miller wrote:
>> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> []
>> >  {
>> >       struct socket *sock;
>> > +     unsigned int poll_result;
>> 
>> Please order local variable declarations from longest line to
>> shortest line.
> 
> reverse christmas tree doesn't seem especially valuable or
> sensible for automatics.

It looks nicer to the eyes and provides a predictable pattern
to look at.
