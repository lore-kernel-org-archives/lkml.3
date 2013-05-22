Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab3EVWLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:11:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45245 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3EVWLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:11:13 -0400
Date: Wed, 22 May 2013 15:11:12 -0700 (PDT)
Message-Id: <20130522.151112.1309391168644175099.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: ben@decadent.org.uk, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] perf: net_dropmonitor: Make it work and make it
 fast
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130521133355.GA3613@neilslaptop.think-freely.org>
References: <1369096976.3469.131.camel@deadeye.wl.decadent.org.uk>
	<20130521133355.GA3613@neilslaptop.think-freely.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 21 May 2013 09:33:56 -0400

> On Tue, May 21, 2013 at 01:42:56AM +0100, Ben Hutchings wrote:
>> Somewhat surprisingly, the net_dropmonitor reporting script doesn't work
>> at all.  This series fixes it and then makes it slightly more efficient.
>> 
>> Ben.
>> 
> It worked fine when I first submitted it.  I wonder if there was a paramter
> order change at some point that I wasn't CC'ed on.
> 
> Either way, this all looks good.  Thanks Ben.
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Series applied, thanks.
