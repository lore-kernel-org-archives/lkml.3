Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300Ab3DPUjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:39:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164Ab3DPUj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:39:29 -0400
Date: Tue, 16 Apr 2013 16:39:27 -0400 (EDT)
Message-Id: <20130416.163927.398727240912142920.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: vitalyb@telenet.dn.ua, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, fubar@us.ibm.com, linux@8192.net
Subject: Re: Bonding driver has bad load balancing for forwarded traffic,
 3.7+
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366122317.4459.135.camel@edumazet-glaptop>
References: <516D1374.1070500@telenet.dn.ua>
	<1366120293.4459.133.camel@edumazet-glaptop>
	<1366122317.4459.135.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Apr 2013 13:39:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 16 Apr 2013 07:25:17 -0700

> On Tue, 2013-04-16 at 06:51 -0700, Eric Dumazet wrote:
> 
>> Perfect, thanks a lot for all this !
>> 
>> Tested-by: Vitaly V. Bursov <vitalyb@telenet.dn.ua>
>> 
>> 
> 
> By the way, we probably should use skb_flow_dissect() to get proper
> hashing for tunnels users.

Agreed but that's net-next material.
