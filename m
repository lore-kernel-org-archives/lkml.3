Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaKWEhC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 23:37:02 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54334 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaKWEg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 23:36:59 -0500
Date: Sat, 22 Nov 2014 23:36:54 -0500 (EST)
Message-Id: <20141122.233654.279540319568229037.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: haiyangz@microsoft.com, kys@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: net: Hyper-V: Deletion of an unnecessary check before the
 function call "vfree"
From: David Miller <davem@davemloft.net>
In-Reply-To: <54712F8C.10206@users.sourceforge.net>
References: <546FB98E.5070703@users.sourceforge.net>
	<20141121.172705.540279259389643572.davem@davemloft.net>
	<54712F8C.10206@users.sourceforge.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Nov 2014 20:36:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 23 Nov 2014 01:51:24 +0100

>> This has nothing to do with me asking you to frame your patches
>> against the correct tree.
> 
> I imagine than someone other can also pick up this update suggestion
> (a simple change of two lines) quicker before I might try another
> software build again from a different commit as a base.

Whereas if you learn how to base your changes cleanly on the correct
base now, all of your future submissions will go quickly and smoothly
into my tree.
