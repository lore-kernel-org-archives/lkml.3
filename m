Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076Ab3DKDXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:23:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55782 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934464Ab3DKDXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:23:35 -0400
Date: Wed, 10 Apr 2013 23:23:33 -0400 (EDT)
Message-Id: <20130410.232333.2201201916427524495.davem@davemloft.net>
To: jk@ozlabs.org
Cc: sfr@canb.auug.org.au, vyasevic@redhat.com, patchwork@lists.ozlabs.org,
        jhbird.choi@samsung.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.8-stable] net: count hw_addr syncs so that unsync
 works properly.
From: David Miller <davem@davemloft.net>
In-Reply-To: <516627B7.1030206@ozlabs.org>
References: <20130410.205401.1135160208998128324.davem@davemloft.net>
	<20130411125954.74150e5689d3f65365947755@canb.auug.org.au>
	<516627B7.1030206@ozlabs.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 10 Apr 2013 20:23:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>
Date: Thu, 11 Apr 2013 13:02:15 +1000

> Hi all,
> 
>>>> This patch looks like it should be in the 3.8-stable tree, should we apply
>>>> it?
>>>
>>> I queue up networking patches as needed and that queue is
>>> visible at:
>>>
>>> http://patchwork.ozlabs.org/user/bundle/2566/?state=*
>> 
>> Actually, this bundle is not visible via that link.  It appears to be a
>> public bundle and visible via
>> http://patchwork.ozlabs.org/bundle/davem/stable/?state=* .  I have
>> insider knowledge :-)
> 
> Perhaps for public bundles, I should make the private link automatically
> redirect to the public one?

Yes.
