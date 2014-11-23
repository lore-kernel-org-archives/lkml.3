Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaKWSjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:39:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34523 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaKWShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:37:35 -0500
Date: Sun, 23 Nov 2014 13:37:29 -0500 (EST)
Message-Id: <20141123.133729.642772258617830867.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: haiyangz@microsoft.com, kys@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: net: Hyper-V: Deletion of an unnecessary check before the
 function call "vfree"
From: David Miller <davem@davemloft.net>
In-Reply-To: <54718A47.20301@users.sourceforge.net>
References: <54712F8C.10206@users.sourceforge.net>
	<20141122.233654.279540319568229037.davem@davemloft.net>
	<54718A47.20301@users.sourceforge.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Nov 2014 10:37:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 23 Nov 2014 08:18:31 +0100

>> Whereas if you learn how to base your changes cleanly on the correct
>> base now, all of your future submissions will go quickly and smoothly
>> into my tree.
> 
> My reluctance to work with more Linux repositories will evolve
> over time. The faster affected software versions can be rebuilt
> the more it will become interesting to try even more source
> code improvements out, won't it?
> 
> I find it nice that you could accept update suggestions for
> a few other Linux components already.

You are seriously starting to waste our time.

Either resubmit your changes against a clean base, or more on.

Seriously, all I am purely interested in is seeing properly submitted
patches, reviewing them, and then integrating them.  Anything else is
pure noise to me.

Thanks.

