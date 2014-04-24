Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaDXCp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:45:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54631 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaDXCpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:45:25 -0400
Date: Wed, 23 Apr 2014 22:45:20 -0400 (EDT)
Message-Id: <20140423.224520.1593121538943289001.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kubakici@wp.pl,
        carolyn.wyborny@intel.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398306278.29638.42.camel@jtkirshe-mobl>
References: <20140424114726.07876050b5b805463a085191@canb.auug.org.au>
	<1398306278.29638.42.camel@jtkirshe-mobl>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Apr 2014 19:45:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 23 Apr 2014 19:24:38 -0700

> On Thu, 2014-04-24 at 11:47 +1000, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Today's linux-next merge of the net-next tree got a conflict in
>> drivers/net/ethernet/intel/igb/e1000_mac.c between commit c5ffe7e1f745
>> ("e1000e/igb/ixgbe/i40e: fix message terminations") from the net tree
>> and
>> commit c75c4edfc38d ("igb: Cleanups for messaging") from the net-next
>> tree.
>> 
>> I fixed it up (the former was a superset of the latter) and can carry
>> the
>> fix as necessary (no action is required).
> 
> Huh, I thought the commit c75c4edfc38d ("igb: Cleanups for messaging")
> in Dave's net-next already took into account the changes in net.  I will
> take a look at your fix Stephen, thanks for letting us know.

Stephen may have pulled net-next before that went in.
