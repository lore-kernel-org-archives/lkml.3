Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbaEFP7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:59:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaEFP7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:59:44 -0400
Date: Tue, 06 May 2014 11:59:41 -0400 (EDT)
Message-Id: <20140506.115941.428706504757835279.davem@davemloft.net>
To: josh@joshtriplett.org
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506155703.GA20391@cloud>
References: <20140506032114.GP2382@two.firstfloor.org>
	<20140505.232327.578134514220748085.davem@davemloft.net>
	<20140506155703.GA20391@cloud>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 08:59:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: josh@joshtriplett.org
Date: Tue, 6 May 2014 08:57:03 -0700

> On Mon, May 05, 2014 at 11:23:27PM -0400, David Miller wrote:
>> From: Andi Kleen <andi@firstfloor.org>
>> Date: Tue, 6 May 2014 05:21:14 +0200
>> 
>> > What parts would you remove to get the foot print down for a 2MB
>> > single purpose machine?
>> 
>> I wouldn't use Linux, end of story.
>> 
>> Maybe two decades ago, but not now, those days are over.
> 
> That's a self-fulfilling prophecy:

Making 2MB RAM machines today makes no sense at all.

The lowest end dirt cheap smartphone, something which fits on
someone's pocket, has gigabytes of ram.

The only entity looking backwards are the people making these
improperly provisioned systems.

