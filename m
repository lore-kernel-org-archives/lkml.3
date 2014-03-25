Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaCYW62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:58:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60585 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbaCYW60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:58:26 -0400
Date: Tue, 25 Mar 2014 18:58:24 -0400 (EDT)
Message-Id: <20140325.185824.890778229733178891.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: zoltan.kiss@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, paul.durrant@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jonathan.davies@citrix.com
Subject: Re: [PATCH net-next] Revert "xen-netback: Aggregate TX unmap
 operations"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395653207.19365.1.camel@kazak.uk.xensource.com>
References: <1395422584-16213-1-git-send-email-zoltan.kiss@citrix.com>
	<1395653207.19365.1.camel@kazak.uk.xensource.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Mar 2014 15:58:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Mon, 24 Mar 2014 09:26:47 +0000

> On Fri, 2014-03-21 at 17:23 +0000, Zoltan Kiss wrote:
>> This reverts commit e9275f5e2df1b2098a8cc405d87b88b9affd73e6. This commit is the
>> last in the netback grant mapping series, and it tries to do more aggressive
>> aggreagtion of unmap operations. However practical use showed almost no
>> positive effect, whilst with certain frontends it causes significant performance
>> regression.
> 
> That's a shame -- do you have any insight into why?
> 
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Applied, thanks.
