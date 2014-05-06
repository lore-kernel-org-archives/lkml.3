Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaEFUGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:06:46 -0400
Received: from one.firstfloor.org ([193.170.194.197]:57917 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaEFUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:06:44 -0400
Date: Tue, 6 May 2014 22:06:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: josh@joshtriplett.org, eric.dumazet@gmail.com, andi@firstfloor.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506200644.GC5619@two.firstfloor.org>
References: <20140506164546.GB20536@cloud>
 <20140506.131752.740569380523989782.davem@davemloft.net>
 <20140506172106.GB20776@cloud>
 <20140506.132501.331724703594119414.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506.132501.331724703594119414.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You see, that's the point I'm trying to make, once it's upstream
> then it's my problem.

FWIW I don't think any of the changes I proposed would be likely
to add lots of new bugs. Nothing was really adding any significant new logic,
just doing less (modulo perhaps fib_list) Was that your main concern?

I realize the many config options are something that could
be consolidated to ease compile time testing.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
