Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaEFUrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:47:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43089 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaEFUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:47:44 -0400
Date: Tue, 06 May 2014 16:47:42 -0400 (EDT)
Message-Id: <20140506.164742.951623564368259138.davem@davemloft.net>
To: andi@firstfloor.org
Cc: josh@joshtriplett.org, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506200644.GC5619@two.firstfloor.org>
References: <20140506172106.GB20776@cloud>
	<20140506.132501.331724703594119414.davem@davemloft.net>
	<20140506200644.GC5619@two.firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 13:47:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 6 May 2014 22:06:44 +0200

>> You see, that's the point I'm trying to make, once it's upstream
>> then it's my problem.
> 
> FWIW I don't think any of the changes I proposed would be likely
> to add lots of new bugs.

Then you're living in a dream world, one in which the rest of us do
not live in.

Every new configuration combination is a new situation that competes
testing wise with the others.
