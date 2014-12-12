Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214AbaLLO36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:29:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35044 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967484AbaLLO34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:29:56 -0500
Date: Fri, 12 Dec 2014 09:29:50 -0500 (EST)
Message-Id: <20141212.092950.1840808214143867233.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: sergei.shtylyov@cogentembedded.com, paulus@samba.org,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
From: David Miller <davem@davemloft.net>
In-Reply-To: <548A92E2.8090304@users.sourceforge.net>
References: <5480DA32.8000201@users.sourceforge.net>
	<20141209.145447.2234157264287438778.davem@davemloft.net>
	<548A92E2.8090304@users.sourceforge.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Dec 2014 06:29:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 12 Dec 2014 08:01:54 +0100

>> Generally speaking, it is advisable to not leave error pointers in data
>> structures, even if they are about to be free'd up in an error path anyways.
>>
>> Therefore I do not like some of the patches in this series.
> 
> Can you give any more concrete feedback here?

I gave you very concrete feedback, I said exactly that I don't want
error pointers left in data structure members.

I cannot describe my requirements any more precisely than that.
