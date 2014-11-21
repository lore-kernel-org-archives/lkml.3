Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaKUW1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:27:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaKUW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:27:09 -0500
Date: Fri, 21 Nov 2014 17:27:05 -0500 (EST)
Message-Id: <20141121.172705.540279259389643572.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: haiyangz@microsoft.com, kys@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: net: Hyper-V: Deletion of an unnecessary check before the
 function call "vfree"
From: David Miller <davem@davemloft.net>
In-Reply-To: <546FB98E.5070703@users.sourceforge.net>
References: <546DF9D7.6080801@users.sourceforge.net>
	<20141121.151503.1986113223309494197.davem@davemloft.net>
	<546FB98E.5070703@users.sourceforge.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 14:27:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 23:15:42 +0100

>> This does not apply to the net-next tree, please respin.
> 
> Thanks for your reply.
> 
> How do you think about to try out the scripts which I published
> in March to get more constructive feedback?

This has nothing to do with me asking you to frame your patches
against the correct tree.

If I had time to investigate automation of changes using such
tools, I would participate in such discussions, but I don't.
