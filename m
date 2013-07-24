Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab3GXARR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:17:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51233 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3GXARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:17:15 -0400
Date: Tue, 23 Jul 2013 17:17:14 -0700 (PDT)
Message-Id: <20130723.171714.1806972255458292929.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: bhutchings@solarflare.com, oliver@neukum.org, grundler@google.com,
        freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, louis@asix.com.tw, allan@asix.com.tw
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374624310.3449.53.camel@edumazet-glaptop>
References: <20130723.164656.1794159338719943519.davem@davemloft.net>
	<1374623813.3449.52.camel@edumazet-glaptop>
	<1374624310.3449.53.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 23 Jul 2013 17:17:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 23 Jul 2013 17:05:10 -0700

> On Tue, 2013-07-23 at 16:56 -0700, Eric Dumazet wrote:
> 
>> > A quick scan shows that smsc75xx, smsc95xx, and ax88179_178a all have
>> > this problem.
>> > 
>> > Instead of the patch starting this thread, I'd like to see one that
>> > hits all three drivers and removes all SG and TSO features bits from
>> > both the ->features _and_ ->hw_features settings.
>> > 
>> > Could someone toss that together quickly?
>> 
>> Yes, I can prepare this patch.
> 
> Looks like only ax88179_178a & smsc75xx are impacted.

Indeed, smsc95xx doesn't set SG or TSO.

Sorry about that.
