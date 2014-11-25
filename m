Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaKYWZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:25:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39406 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaKYWZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:25:10 -0500
Date: Tue, 25 Nov 2014 17:25:05 -0500 (EST)
Message-Id: <20141125.172505.1865008364622013273.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: devel@linuxdriverproject.org, netdev@vger.kernel.org,
        haiyangz@microsoft.com, kys@microsoft.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH v2] net: Hyper-V: Deletion of an unnecessary check
 before the function call "vfree"
From: David Miller <davem@davemloft.net>
In-Reply-To: <5474FAD6.4060704@users.sourceforge.net>
References: <546DF9D7.6080801@users.sourceforge.net>
	<20141121.151503.1986113223309494197.davem@davemloft.net>
	<5474FAD6.4060704@users.sourceforge.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Nov 2014 14:25:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 25 Nov 2014 22:55:34 +0100

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 25 Nov 2014 22:33:45 +0100
> 
> The vfree() function performs also input parameter validation.
> Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied, thanks.
