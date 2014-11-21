Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaKUUPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:15:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38470 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaKUUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:15:07 -0500
Date: Fri, 21 Nov 2014 15:15:03 -0500 (EST)
Message-Id: <20141121.151503.1986113223309494197.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: haiyangz@microsoft.com, kys@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH 1/1] net: Hyper-V: Deletion of an unnecessary check
 before the function call "vfree"
From: David Miller <davem@davemloft.net>
In-Reply-To: <546DF9D7.6080801@users.sourceforge.net>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<546DF9D7.6080801@users.sourceforge.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 12:15:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 15:25:27 +0100

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 20 Nov 2014 15:15:21 +0100
> 
> The vfree() function performs also input parameter validation. Thus the test
> around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

This does not apply to the net-next tree, please respin.
